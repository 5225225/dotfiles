local assdraw = require 'mp.assdraw'
local msg = require 'mp.msg'
local opt = require 'mp.options'
local utils = require 'mp.utils'

-- default options, convert_script.conf is read
local options = {
    bitrate_multiplier = 0.975,			-- to make sure the file won’t go over the target file size, set it to 1 if you don’t care
    output_directory = "$HOME",
    use_pwd_instead = false,			-- overrides output_directory
    use_same_dir = false,			-- puts the output files where the original video was
    libvpx_threads = 4,				-- libvpx only
    crop_individually = true,
    libvpx_options = "--ovcopts-add=cpu-used=0,auto-alt-ref=1,lag-in-frames=25,quality=good",
    libvpx_vp9_options = "",
    legacy_yad = false,				-- if you don’t want to upgrade to at least yad 0.18
    libvpx_fps = "--oautofps",			-- --ofps=24000/1001 for example
    audio_bitrate = 112,			-- mpv default, in kbps
}

read_options(options, "convert_script")
options.output_directory = '"' .. options.output_directory .. '"'
yad_table = {}

-------------------------------------
-- Rectangle selection and drawing --
-------------------------------------

alpha = 180
rect_x1, rect_x2, rect_y1, rect_y2 = 0, 0, 0, 0

function render()

    ass = assdraw.ass_new()
    ass:draw_start()
    ass:append(string.format("{\\1a&H%X&}", alpha))
    ass:rect_cw(rect_x1, rect_y1, rect_x2, rect_y2)
    ass:pos(0, 0)
    ass:draw_stop()
    mp.set_osd_ass(width, height, ass.text)
    
end


function tick()
    
    if set_mouse_area then
        mp.set_mouse_area(0, 0, width, height, "draw_rectangle")
    end
    
end



function rect_button_press_event(mouse, event)
    
    if event == "down" then
        
	rect_x1, rect_y1 = mp.get_mouse_pos()
	rect_x2, rect_y2 = rect_x1, rect_y1
	button_pressed = true

    elseif event == "up" then
        
	button_pressed = nil
	if (rect_x1  == rect_x2) and (rect_y1 == rect_y2) then
            mp.set_osd_ass(width, height, "")
	end
	
	if rect_x2 > rect_x1 then
	    rect_width =  rect_x2 - rect_x1
	else
	    rect_width =  rect_x1 -rect_x2
	    rect_x1 = rect_x2
	end
	if rect_y2 > rect_y1 then
	    rect_height =  rect_y2 - rect_y1
	else
	    rect_height =  rect_y1 -rect_y2
	    rect_y1 = rect_y2
	end
        if rect_x1 < 0 then
            rect_x1 = 0
        end
        if rect_y1 < 0 then
            rect_y1 = 0
        end
        if (rect_width + rect_x1) >= tonumber(width) then
            rect_width = width - rect_x1
        end
        if (rect_height + rect_y1) >= tonumber(height) then
            rect_height = height - rect_y1
        end
	call_gui()
	
    end
end


function mouse_move()
    
    if button_pressed then
	rect_x2, rect_y2 = mp.get_mouse_pos()
	render()
    end
    
end



-----------------
-- Main script --
-----------------

function convert_script_hotkey_call ()

    if mp.get_property("playback-time") then
        playback_time = "playback-time"
    else
        playback_time = "time-pos"
    end
    
    set_mouse_area = true
    width = mp.get_property("dwidth")
    height = mp.get_property("dheight")
    mp.set_osd_ass(width, height, "")
    
    if timepos1 then
        
	timepos2 = mp.get_property_native(playback_time)
	timepos2_humanreadable = mp.get_property_osd(playback_time)
	
	if tonumber(timepos1) > tonumber(timepos2) then
            
            length = timepos1-timepos2
            start = timepos2
	    start_humanreadable = timepos2_humanreadable
	    end_humanreadable = timepos1_humanreadable
	    msg.info("End frame set")
	    
	elseif tonumber(timepos2) > tonumber(timepos1) then
	    
	    length = timepos2-timepos1
	    start = timepos1
	    start_humanreadable = timepos1_humanreadable
	    end_humanreadable = timepos2_humanreadable
	    msg.info("End frame set")
	
	else
	
	    msg.error("Both frames are the same, ignoring the second one")
	    mp.osd_message("Both frames are the same, ignoring the second one")
	    timepos2 = nil
	    return
        
	end
	
	timepos1 = nil
	call_gui()
	
    else
        
	timepos1 = mp.get_property_native(playback_time)
	timepos1_humanreadable = mp.get_property_osd(playback_time)
        msg.info("Start frame set")
        mp.osd_message("Start frame set")
    
    end

end


------------
-- Encode --
------------

function preparations()

    video = mp.get_property("path")
    video = string.gsub(video, "'", "'\\''")
    
    if options.use_pwd_instead then
    
        local pwd = os.getenv("PWD")
        pwd = string.gsub(pwd, "'", "'\\''")
        options.output_directory = "'" .. pwd .. "'"
        
    end
    if options.use_same_dir then
        options.output_directory = "'" .. utils.split_path(video) .. "'"
    end
    
    local filename_ext = mp.get_property_osd("media-title")
    filename_ext = string.gsub(filename_ext, "'", "'\\''")
    local filename = string.gsub(filename_ext, "%....$","")
    metadata_title = filename
    
    if string.len(filename) > 230 then
    
        filename = mp.get_property("options/title")
        if filename == 'mpv - ${media-title}' or string.len(filename) > 230 then
            filename = 'output'
        end
        
    end
    
    filename = filename .. " " .. start_humanreadable .. "-" .. end_humanreadable .. extension
    filename = string.gsub(filename, ":", ".")
    full_output_path = options.output_directory .. "/'" .. filename .. "'"

end

function encode(enc)

    set_mouse_area = nil
    if rect_width == nil or rect_width == 0 then
        crop = ""
        if not aspect_first then
            aspect_first = mp.get_property_native("video-params/aspect")
        end
    else
        -- odd numbers for video resolution are a bad idea
        rect_width = round(rect_width) - (math.fmod(round(rect_width), 2))
        rect_height = round(rect_height) - (math.fmod(round(rect_height), 2))
        crop = rect_width .. ":" .. rect_height .. ":" .. round(rect_x1) .. ":" .. round(rect_y1)
        if not aspect_first then
            aspect_first = rect_width / rect_height
            width_first = rect_width
            height_first = rect_height
            if not no_scale then
                if scale_width then
                    width_first = scale
                else
                    height_first = scale
                end
            end
        end
        rect_width, rect_height = nil
    end
    
    local sid = mp.get_property("sid")
    local sub_visibility = mp.get_property("sub-visibility")
    local aid = ""
    aid = " --aid=" .. mp.get_property("aid")
    local af = mp.get_property("af")
    local vf = mp.get_property("vf")
    if string.len(vf) > 0 then
        vf = vf .. ","
    end
    local sub_file_table = mp.get_property_native("options/sub-file")
    local sub_file = ""
    for index, param in pairs(sub_file_table) do
        sub_file = sub_file .. " --sub-file='" .. string.gsub(tostring(param), "'", "'\\''") .. "'"
    end
    local audio_file_table = mp.get_property_native("options/audio-file")
    local audio_file = ""
    for index, param in pairs(audio_file_table) do
        audio_file = audio_file .. " --audio-file='" .. string.gsub(tostring(param), "'", "'\\''") .. "'"
    end
    if mp.get_property_native("mute") then
        audio_file = ""
        aid = ""
        audio = "--no-audio"
    end
    local sub_auto = mp.get_property("options/sub-auto")
    local sub_delay = mp.get_property("sub-delay")
    local hr_seek_demuxer_offset = mp.get_property_native("options/hr-seek-demuxer-offset")
    
    preparations()
    
    if options.crop_individually then
        vf = vf .. 'sub,crop=' .. crop .. ',scale=SCALE…VAR'
    else
        vf = vf .. 'sub,crop=CROP…VAR,scale=SCALE…VAR'
    end

    local mpv_options = "'" .. video .. "' --start=+" .. start .. ' --length=' .. length
    .. ' ' .. sub_file .. ' --sid=' .. sid .. ' --sub-visibility=' .. sub_visibility
    .. ' --sub-delay=' .. sub_delay .. ' --sub-auto=' .. sub_auto .. aid
    .. ' --vf-add=' .. vf .. ' --hr-seek-demuxer-offset=' .. hr_seek_demuxer_offset
    .. ' --af=' .. af .. ' ' .. audio_file
    
    if not (ovc == "gif") then
        ovc_c = ' --ovc=' .. ovc
    else
        ovc_c = ' '
    end
    local encode_options = ' ' .. ovc_c
    if ovc == "libvpx" or ovc == "libvpx-vp9" then
        encode_options = encode_options .. ' ' .. options.libvpx_fps .. ' --ovcopts-add=threads=' .. options.libvpx_threads .. ' '
        if ovc == "libvpx" then
            encode_options = encode_options .. options.libvpx_options
        else
            encode_options = encode_options .. options.libvpx_vp9_options
            --libvpx-vp9 produces slightly bigger files
            if bitrate then
                bitrate = bitrate * 0.93
            end
        end
        
        
    end
    if twopass then
        encode_options = encode_options .. ' --ovcopts-add=b=' .. bitrate
    else
        if not (ovc == "gif") then
            encode_options = encode_options .. ' --ovcopts-add=crf=' .. tostring(crf)
        end
        if ovc == "libvpx" or ovc == "libvpx-vp9" then 
            encode_options = encode_options .. ' --ovcopts-add=b=10000000'
        end
    end
    
    if advanced then
        encode_options = ' ' .. advanced_output .. advanced_encode
    end
    
    if not segments then
        segments = ""
        segment_count = 0
    end
    segment_count = segment_count + 1
    
    segments = segments .. " --\\{ " .. mpv_options .. " --\\}"
    
    local full_command = '( mpv' .. segments
    if twopass then
        encode_options = encode_options  .. ' --ovcopts-add=flags=+pass'
        full_command = full_command .. ' --no-audio ' .. encode_options .. '1'
    end
    if ovc == "gif" then
        local handle = io.popen("mktemp -d")
        tmpfolder = handle:read("*a")
        handle:close()
        tmpfolder = string.gsub(tmpfolder, '\n', '')
        encode_options = encode_options .. ' --no-keep-open --vo=image:format=png:outdir=' .. tmpfolder
    else
        full_command = full_command .. ' --o=' .. full_output_path
    end
    if twopass then
        full_command = full_command .. ' && mpv' .. segments  .. ' ' .. audio .. ' ' .. encode_options .. '2'
        .. ' --o=' .. full_output_path
        .. ' && rm ' .. full_output_path .. '-vo-lavc-pass1.log'
    else
        full_command = full_command .. ' ' .. audio .. ' ' .. encode_options
    end
    
    if not framestep then
        framestep = 1
        dither = "+dither"
        fuzz = "1%"
    end
    local delay = framestep * 4
    if ovc == "gif" then
        full_command = full_command .. ' --vf-add=lavfi=graph=\\"framestep=' .. framestep .. '\\" && convert ' 
        .. tmpfolder .. '/*.png -set delay ' .. delay .. ' -loop 0 -fuzz ' .. fuzz .. '% ' .. dither .. ' -layers optimize '
        .. full_output_path .. ' && rm -rf ' .. tmpfolder .. ' && notify-send "Gif done") & disown'
    else
        full_command = full_command .. ' && notify-send "Encoding done"; mkvpropedit '
        .. full_output_path .. ' -s title="' .. metadata_title .. '") & disown'
    end
    
    
    if enc then
    
        -- mpv parses --{ --} last and --no-audio gets overwritten by --aid, so remove them
        if audio == "--no-audio" then
            full_command = string.gsub(full_command, "--aid=%d* ", " ")
        end
        local dwidth, dheight = mp.get_property_native("dwidth"), mp.get_property_native("dheight")
        
        if width_first then
            if scale_width then
                scale = width_first
            else
                scale = height_first
            end
        end
    
        if scale_width then
            local scale_2 = round(scale / aspect_first)
            scale = scale .. ":" .. (scale_2 - (math.fmod(scale_2, 2)))
        else
            local scale_2 = round(scale * aspect_first)
            scale = (scale_2 - math.fmod(scale_2, 2)) .. ":" .. scale
        end
        if no_scale and not width_first then
           scale = dwidth .. ":" .. dheight
        end
        
        full_command = string.gsub(full_command, "CROP…VAR", crop)
        full_command = string.gsub(full_command, "SCALE…VAR", scale)
        msg.info(full_command)
        os.execute(full_command)
        clear()
        
    end
end

function encode_copy(enc)

    preparations()
    if not mkvmerge_parts then
        mkvmerge_parts = "--split parts:"
        sep = ""
    end
    
    mkvmerge_parts = mkvmerge_parts .. sep .. math.floor(start) .. "s-" .. math.ceil(start + length) .. "s"
    sep = ",+"
    
    if enc then
        local command = "mkvmerge '" .. video .. "' " .. mkvmerge_parts .. " -o " .. full_output_path
        msg.info(command)
        os.execute(command)
        clear()
    end

end

function clear()

    mkvmerge_parts = nil
    aspect_first = nil
    height_first = nil
    width_first = nil
    sep = nil
    segments = nil
    segments_length = 0
    
end

---------
-- GUI --
---------

function call_gui ()

    mp.disable_key_bindings("draw_rectangle")
    mp.resume_all()
    extension = ""
    local factor = 1024
    local format_dropdown_content
    local mode_dropdown_content
    local resize_to_width_instead
    local include_audio
    local yad_offset_10 = 0
    
    if not scale_sav then
        scale_sav = 540
    end
    if not yad_table[5] then
        yad_table[5] = ""
    end
    
    if not options.legacy_yad then
    
        if yad_table[5]:find("(MiB)") then
            mode_dropdown_content = "'Target file size (KiB)!^Target file size (MiB)!CRF'"
        elseif yad_table[5]:find("(KiB)") then
            mode_dropdown_content = "'^Target file size (KiB)!Target file size (MiB)!CRF'"
        elseif yad_table[5]:find("CRF") then
            mode_dropdown_content = "'Target file size (KiB)!Target file size (MiB)!^CRF'"
        else
            mode_dropdown_content = "'^Target file size (KiB)!Target file size (MiB)!CRF'"
        end
        
        if yad_table[7] == "vp8/webm" then
            format_dropdown_content = "'^vp8/webm!vp9/webm!h264/mkv!h264/mp4!h265/mkv!gif!stream copy/mkv'"
        elseif yad_table[7] == "vp9/webm" then
            format_dropdown_content = "'vp8/webm!^vp9/webm!h264/mkv!h264/mp4!h265/mkv!gif!stream copy/mkv'"
        elseif yad_table[7] == "h264/mkv" then
            format_dropdown_content = "'vp8/webm!vp9/webm!^h264/mkv!h264/mp4!h265/mkv!gif!stream copy/mkv'"
        elseif yad_table[7] == "h264/mp4" then
            format_dropdown_content = "'vp8/webm!vp9/webm!h264/mkv!^h264/mp4!h265/mkv!gif!stream copy/mkv'"
        elseif yad_table[7] == "h265/mkv" then
            format_dropdown_content = "'vp8/webm!vp9/webm!h264/mkv!h264/mp4!^h265/mkv!gif!stream copy/mkv'"
        elseif yad_table[7] == "gif" then
            format_dropdown_content = "'vp8/webm!vp9/webm!h264/mkv!h264/mp4!h265/mkv!^gif!stream copy/mkv'"
        elseif yad_table[7] == "stream copy/mkv" then
            format_dropdown_content = "'vp8/webm!vp9/webm!h264/mkv!h264/mp4!h265/mkv!gif!^stream copy/mkv'"
        else
            format_dropdown_content = "'^vp8/webm!vp9/webm!h264/mkv!h264/mp4!h265/mkv!gif!stream copy/mkv'"
        end
        
    else
        mode_dropdown_content = "'Target file size (KiB)!Target file size (MiB)!CRF'"
        format_dropdown_content = "'vp8/webm!vp9/webm!h264/mkv!h264/mp4!h265/mkv!gif!stream copy/mkv'"
        yad_offset_10 = -2
    end
        
    
        
    
    if (yad_table[2] == "TRUE") then
        resize_to_width_instead = '"true"'
    else
        resize_to_width_instead = '"false"'
    end
    
    if (yad_table[4] == "TRUE") then
        include_audio = '"true"'
    else
        include_audio = '"false"'
    end
    
    if (not yad_table[6]) then
        yad_table[6] = '"3072"'
    end
    
    
    local yad_command = [[LC_NUMERIC=C yad --title="Convert Script" --center --form --fixed --always-print-result \
    --name "convert script" --class "Convert Script" --field="Resize to height:NUM" "]] .. scale_sav		--yad_table 1
    .. [[" --field="Resize to width instead:CHK" ]] .. resize_to_width_instead .. " "				--yad_table 2
    if options.legacy_yad then
        yad_command = yad_command .. [[--field="Don't resize at all:CHK" "false" ]]
    else
        yad_command = yad_command
        .. [[--field="Don't resize at all:BTN" "@bash -c 'if ]] .. '[[ "a%1" ==  "a0.000000" ]]'
        .. [[; then printf '\''1:1\n2:false'\''; else printf '\''1:0.000000\n1:@disabled@\n2:@disabled@'\''; fi'" ]]
    end
    yad_command = yad_command .. '--field="Include audio:CHK" ' .. include_audio .. ' ' 			--yad_table 4
    
    if yad_ret then
        yad_command = yad_command
        .. [[--field="2pass:CHK" "false" ]]									--yad_table 5
        .. [[--field="Encode options::CBE" '! --ovcopts=b=2000,cpu-used=0,auto-alt-ref=1,lag-in-frames=25,quality=good,threads=4' ]]	--yad_table 6
        .. [[--field="Output format::CBE" ' --ovc=libx264! --oautofps --of=webm --ovc=libvpx' ]]		
        .. [[--field="Simple:FBTN" 'bash -c "echo \"simple\" && kill -s SIGUSR1 \"$YAD_PID\""' ]]
        advanced = true
    else
        yad_command = yad_command
        .. '--field="Mode::CB" ' .. mode_dropdown_content							--yad_table 5
        .. ' --field="Value::NUM" ' .. yad_table[6]								--yad_table 6
        .. ' --field="Output format::CB" ' .. format_dropdown_content						--yad_table 7
        if not options.legacy_yad then
            yad_command = yad_command .. [[ --field="Advanced:FBTN" 'bash -c "echo \"advanced\" && kill -s SIGUSR1 \"$YAD_PID\""' ]]
        end
    end
    if not options.legacy_yad then
        yad_command = yad_command
        .. [[--field="Append another segment:FBTN" 'bash -c "echo \"append\" && kill -s SIGUSR1 \"$YAD_PID\""' ]]
    end
    yad_command = yad_command .. [[ --button="Crop:1" --button="gtk-cancel:2" --button="gtk-ok:0"; ret=$? && echo $ret]]
    
    if gif_dialog then
        yad_command = [[echo $(LC_NUMERIC=C yad --title="Gif settings" --name "convert script" --class "Convert Script" \
        --center --form --always-print-result --separator="…" \
        --field="Fuzz Factor:NUM" '1!0..100!0.5!1' \
        --field="Framestep:NUM" '3!1..3!1' \
        --field="Dither:CB" 'None!E-Dither!Ordered Dither' \
        --button="Ok:0")]]
    end

    local handle = io.popen(yad_command)
    local yad = handle:read("*a")
    handle:close()
    if yad == "127\n" then
        msg.error("Error: Cannot find yad!")
        mp.osd_message("Error: Cannot find yad!")
        return
    end
    yad_table = {}
    local function helper(line) table.insert(yad_table, line) return "" end
    helper((yad:gsub("(.-)|", helper)))
    for i, e in pairs(yad_table) do
        msg.debug(i .. "       →      " .. e)
    end
    
    if not gif_dialog then
    
        yad_ret = tonumber(yad_table[10+yad_offset_10])
        if yad_table[1]:find("append") then
            yad_table[1] = string.gsub(yad_table[1], "append\n", "")
            yad_ret = -1
        end
        if yad_table[1]:find("advanced") then
            yad_table[1] = string.gsub(yad_table[1], "advanced\n", "")
            yad_ret = -2
            if yad_table[7]:find("gif") then
                gif_dialog = true
            end
        end
        if yad_table[1]:find("simple") then
            yad_table[1] = string.gsub(yad_table[1], "simple\n", "")
            yad_ret = -2
        end
        
        scale = tonumber(yad_table[1]) - (math.fmod(tonumber(yad_table[1]), 2 ))
        scale_sav = scale
        if (yad_table[2] == "FALSE") and (tonumber(yad_table[1]) > 0) then
            scale_width = false
            no_scale = false
        elseif yad_table[1] == "0.000000" then
            no_scale = true
        else
            scale_width = true
            no_scale = false
        end
        if yad_table[3] == "TRUE" then
            no_scale = true
        end
    
        if yad_table[4] == "FALSE" then
            audio = "--no-audio"
        else
            audio = ""
        end
    
        if not segments_length then
            segments_length = 0
        end
    
        segments_length = segments_length + length
    
        if (yad_table[5] == "TRUE") or yad_table[5]:find("Target") then
            twopass = true
        else
            twopass = false
        end
    
        if advanced then
            advanced_encode = yad_table[6]
            advanced_output = yad_table[7]
            yad_table[6] = '"3072"'
        else
            if yad_table[7]:find("webm") then
                extension = ".webm"
            elseif yad_table[7]:find("mkv") then
                extension = ".mkv"
            elseif yad_table[7]:find("mp4") then
                extension = ".mp4"
            end
        
            if yad_table[7]:find("h264") then
                ovc = "libx264"
            elseif yad_table[7]:find("h265") then
                ovc = "libx265"
            elseif yad_table[7]:find("vp8") then
                ovc = "libvpx"
            elseif yad_table[7]:find("vp9") then
                ovc = "libvpx-vp9"
            elseif yad_table[7]:find("gif") then
                ovc = "gif"
                extension = ".gif"
                twopass = false
            elseif yad_table[7]:find("stream copy") then
                ovc = "stream copy"
            end
        
            if yad_table[5]:find("(MiB)") then
                factor = 1048576
            end
            if twopass then
                local total_bitrate = yad_table[6] * factor
                if audio == "" then
                    total_bitrate = total_bitrate - ( options.audio_bitrate * 1000 * segments_length / 8 )
                end
                bitrate = math.floor(total_bitrate*8/segments_length*options.bitrate_multiplier)
            else
                crf = yad_table[6]
            end
            
        end
        
        if yad_ret == 1 then
            mp.enable_key_bindings("draw_rectangle")
            yad_ret = nil
            return
        end
        
    else
    
        gif_dialog = nil
        helper((yad:gsub("(.-)…", helper)))
        fuzz = yad_table[2]
        framestep = yad_table[3]
        if yad_table[4] == "None" then
            dither = "+dither"
        elseif yad_table[4] == "Ordered Dither" then
            dither = "-ordered-dither o8x8,20"
        else
            dither = ""
        end
        yad_table[7] = "gif"
    
    end
    
    
    mp.set_osd_ass(width, height, "")
    
    if yad_ret == 0 then
        if ovc == "stream copy" then
            encode_copy(true)
        else
            encode(true)
        end
    elseif yad_ret == -1 then
        if ovc == "stream copy" then
            encode(false)
            encode_copy(false)
        else
            encode(false)
            encode_copy(false)
        end
    end
    
    if yad_ret == -2 then
        if advanced then
            advanced = false
            yad_ret = false
        end
        call_gui()
    end
    
    if yad_ret == 2 then
        clear()
    end
    yad_ret = nil
    advanced = nil

end

function round(n)
    return math.floor((math.floor(n*2) + 1)/2)
end




mp.set_key_bindings({
    {"mouse_move", mouse_move},
    {"mouse_btn0", function(e) rect_button_press_event("mouse_btn0", "up") end, function(e) rect_button_press_event("mouse_btn0", "down") end},
}, "draw_rectangle", "force")

mp.add_key_binding("c", "convert_script", convert_script_hotkey_call)

mp.register_event("tick", tick)
