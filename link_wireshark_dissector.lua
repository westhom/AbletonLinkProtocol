-- Ableton Link Wireshark protocol dissector (in progress; please contribute/correct)
trivial_proto = Proto("trivial","Ableton Link")

-- create a function to dissect it
function trivial_proto.dissector(buffer,pinfo,tree)
    pinfo.cols.protocol = "LNK"
    local subtree = tree:add(trivial_proto,buffer(),"Ableton Link Datagram Protocol")
    subtree:add(buffer(7,1),"Protocol version: " .. buffer(7,1):uint())
    subtree:add(buffer(8,1),"Message type: " .. buffer(8,1):uint())
    subtree:add(buffer(9,1),"Message subtype: " .. buffer(9,1):uint())
    subtree:add(buffer(12,8),"Client ID: " .. buffer(12,8):string())

    -- 20 byte packet (disconnect type) won't have the info below
    if buffer:len() == 20 then return end

    subtree:add(buffer(20,4),"Timeline marker")
    subtree:add(buffer(24,4),"Packets per beat: " .. buffer(24,4):uint())

    local mspb = buffer(28,8):uint64()
    subtree:add(buffer(28,8),"Microseconds per beat: " .. mspb .. " (" .. (60000000/mspb) .. " bpm)")

    subtree:add(buffer(36,8),"Elapsed microbeats: " .. buffer(36,8):uint64())

    local elapsed_ms = buffer(44,8):uint64()
    local elapsed_hrs = elapsed_ms / 1000000 / 60 / 60
    local elapsed_mins = (elapsed_ms / 1000000 / 60) - (elapsed_hrs * 60)
    local elapsed_seconds = (elapsed_ms / 1000000) - ((elapsed_hrs * 60 * 60) + (elapsed_mins * 60))
    subtree:add(buffer(44,8),"Elapsed microseconds: " .. elapsed_ms .. " (" .. elapsed_hrs .."hr " .. elapsed_mins .. "m ".. elapsed_seconds .. "s)")
    
    subtree:add(buffer(52,4),"Session marker")
    subtree:add(buffer(56,4),"Session Unknown: " .. buffer(56,4):uint())
    subtree:add(buffer(60,8),"Session ID: " .. buffer(60,8):string())
end
-- load the udp.port table
udp_table = DissectorTable.get("udp.port")
-- register our protocol to handle udp port 20808
udp_table:add(20808,trivial_proto)