--[[
 * @description Mute - unmute tracks by region render matrix 
 * @about This script will mute or unmute tracks per region, based on the region render matrix. 
It can be usefull when using the SWS Region Playlist. You can easily create arrangements with regions and muting / unmuting track in the region render matrix. 
By the way, it has nothing to do with rendering of regions, it's just using the Region Render Matrix for muting / unmuting the tracks.

Instructions:
1. create some tracks
2. create some regions
3. start the script
4. use the Region Render Matrix to mute / unmute tracks per region

 * @author Michel de Joode
 * @version 1.0
 * Licence: GPL v3
 * REAPER: 6.0+
 * Extensions: none required, but SWS Region Playlist makes this script usefull
--]]



local oldregion

function mute_tracks() 
-- get current region-id
markeridx, region_idx = reaper.GetLastMarkerAndCurRegion( 0,reaper.GetPlayPosition2() )
region_idx = region_idx+1

--only execute code if region has changed
if region_idx ~= oldregion then

oldregion = region_idx
counttracks = reaper.CountTracks(0)
muted_tracks = {}
-- mute tracks which are marked in region render matrix
for index = 0, counttracks do -- for all tracks
track = reaper.EnumRegionRenderMatrix(0, region_idx, index) 
if track ~= nil then
reaper.SetMediaTrackInfo_Value(track, 'B_MUTE', 1)
muted_tracks[index] = track
end -- end if track ~= nil
end -- end for index =0


for index = 0, counttracks do --unmute tracks except muted tracks
isin = 0
for i = 0, counttracks do
if reaper.GetTrack(0, index) == muted_tracks[i] then
isin = 1
end -- end if gettrack
end -- end for i 

if isin == 0 then -- if the track is not muted, unmute track

track = reaper.GetTrack(0, index)
if track ~= nil then
reaper.SetMediaTrackInfo_Value(track, 'B_MUTE', 0)
end -- end if track
end -- end for do unmute tracks
end
end -- if region other than oldregion
end -- end function mute_tracks


-- defer this script
function deferscript()
   if reaper.GetPlayState() == 1 then
    mute_tracks()
    reaper.defer(deferscript)
    else
    reaper.defer(deferscript)
  end
end
deferscript()
