local constants = require('ouest_freestyle_station.constants')

local helpers = {}

local _minExtent = 0.1
local _tolerance = 0.1

helpers.getPlatformStretchFactor = function(length, width)
    if width < 10 and length <= 4 then return 1.075 end

    local lengthAdjusted = math.max(length, 4) -- 4 is the shape step of our platform tracks, incidentally
    local widthAdjusted = math.max(width, 5) -- narrow platforms are trickier than it appears they should
    return 1 + widthAdjusted / lengthAdjusted * 0.06
end

helpers.getSlopedPlatformStretchFactor = function(length, width)
    return 1
    -- if width < 10 and length <= 4 then return 1.075 end

    -- local lengthAdjusted = math.max(length, 4) -- 4 is the shape step of our platform tracks, incidentally
    -- local widthAdjusted = math.max(width, 5) -- narrow platforms are trickier than it appears they should
    -- return 1 + widthAdjusted / lengthAdjusted * 0.06
end

helpers.getPlatformTrackEraCPassengerMaterials = function()
    return {
        'ouest_train_station/era_c_station_tiles_1.mtl',
        'ouest_train_station/station_concrete_1.mtl',
        'ouest_train_station/era_c_station_tiles_1_z.mtl',
        'ouest_train_station/station_concrete_1_z.mtl',
    }
end

helpers.getTrackBoundingInfo = function(length, width, height)
    local adjustedLength = 1
    local adjustedWidth = 1
    local x = math.max(adjustedLength * 0.5 - _tolerance, _minExtent)
    local y = math.max(adjustedWidth * 0.5 - _tolerance, _minExtent)
    local z = math.max(height * 0.5 - _tolerance, _minExtent)
    return {
        bbMax = {
            x, y, height * 0.5 + z
        },
        bbMin = {
            -x, -y, height * 0.5 - z
        },
    }
end

helpers.getTrackCollider = function(length, width, height)
    local adjustedLength = 1
    local adjustedWidth = 1
    return {
        params = {
            halfExtents = {
                math.max(adjustedLength * 0.5 - _tolerance, _minExtent),
                math.max(adjustedWidth * 0.5 - _tolerance, _minExtent),
                math.max(height * 0.5 - _tolerance, _minExtent),
            },
        },
        transf = { 1, 0, 0, 0,  0, 1, 0, 0,  0, 0, 1, 0,  0, 0, height * 0.5, 1, },
        type = 'BOX',
    }
end

helpers.getVoidBoundingInfo = function()
    return {} -- this seems the same as the following
    -- return {
    --     bbMax = { 0, 0, 0 },
    --     bbMin = { 0, 0, 0 },
    -- }
end

helpers.getVoidCollider = function()
    -- return {
    --     params = {
    --         halfExtents = { 0, 0, 0, },
    --     },
    --     transf = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, },
    --     type = 'BOX',
    -- }
    return {
        type = 'NONE'
    }
end

helpers.getVoidLods = function ()
    return {
        {
            node = {
                -- name = 'RootNode',
            },
            static = false,
            visibleFrom = 0,
            visibleTo = 100,
        },
    }
end

return helpers