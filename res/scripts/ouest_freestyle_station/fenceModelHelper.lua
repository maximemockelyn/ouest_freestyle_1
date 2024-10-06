local arrayUtils = require('ouest_freestyle_station.arrayUtils')
local constants = require('ouest_freestyle_station.constants')

local _platformHeightsSorted = {}

for _, plh in pairs(constants.platformHeights) do
    _platformHeightsSorted[#_platformHeightsSorted + 1] = plh
end

arrayUtils.sort(_platformHeightsSorted, 'aboveRail', true)

local _getZShiftDefaultIndex = function()
    local index_base0 = 0

    for _, plh in pairs(_platformHeightsSorted) do
        if plh.aboveGround == constants.defaultPlatformHeight then
            return index_base0
        end
        index_base0 = index_base0 + 1
    end

    return 0
end

local privateValues = {
    maxLength = 200,
    yShiftMaxIndex = 24,
    yShiftFineMaxIndex = 5,
    zDeltaMaxIndex = 64,
    zRotationMaxIndex = 64,
}

privateValues.defaults = {
    -- lolloFenceAssets_buildOnFrozenEdges = 0,
    ouestFenceAssets_doTerrain = 1,
    ouestFenceAssets_isWallTall = 0,
    ouestFenceAssets_length = 9,
    ouestFenceAssets_model = 1,
    ouestFenceAssets_wallEraPrefix = 0,
    ouestFenceAssets_wallBehindModel = 0,
    ouestFenceAssets_wallBehindInTunnels = 0,
    ouestFenceAssets_wallBehindOnBridges = 0,
    ouestFenceAssets_yShift = privateValues.yShiftMaxIndex + 5,
    ouestFenceAssets_yShiftFine = privateValues.yShiftFineMaxIndex,
    ouestFenceAssets_zDelta = privateValues.zDeltaMaxIndex,
    ouestFenceAssets_zRotation = privateValues.zRotationMaxIndex,
    ouestFenceAssets_zShift = _getZShiftDefaultIndex(),
}

local privateFuncs = {
    getLengthValues = function()
        local results = {}
        for i = 1, privateValues.maxLength, 1 do
            results[#results + 1] = tostring(i)
        end
        return results
    end,

    getYShiftActualValues = function()
        local results = {}
        for i = -privateValues.yShiftMaxIndex, privateValues.yShiftMaxIndex, 1 do
            results[#results + 1] = i / 2
        end
        return results
    end,

    getYShiftDisplayValues = function()
        local results = {}
        for i = -privateValues.yShiftMaxIndex, privateValues.yShiftMaxIndex, 1 do
            results[#results + 1] = ("%.3g"):format(i / 2)
        end
        return results
    end,

    getYShiftFineActualValues = function()
        local results = {}
        for i = -privateValues.yShiftFineMaxIndex, privateValues.yShiftFineMaxIndex, 1 do
            results[#results + 1] = i * 0.1
        end
        return results
    end,

    getYShiftFineDisplayValues = function()
        local results = {}
        for i = -privateValues.yShiftFineMaxIndex, privateValues.yShiftFineMaxIndex, 1 do
            results[#results + 1] = ("%.3g"):format(i * 0.1)
        end
        return results
    end,

    getZDeltaActualValues = function()
        local results = {}
        for i = -privateValues.zDeltaMaxIndex, privateValues.zDeltaMaxIndex, 1 do
            results[#results + 1] = i / privateValues.zDeltaMaxIndex
        end
        return results
    end,

    getZDeltaDisplayValues = function()
        local results = {}
        for i = -privateValues.zDeltaMaxIndex, privateValues.zDeltaMaxIndex, 1 do
            results[#results + 1] = ("%.3g %%"):format(i * 100 / privateValues.zDeltaMaxIndex)
        end
        return results
    end,

    getZRotationActualValues = function()
        local results = {}
        for i = -privateValues.zRotationMaxIndex, privateValues.zRotationMaxIndex, 1 do
            results[#results + 1] = tostring(i * math.pi / 2 / privateValues.zRotationMaxIndex)
        end
        return results
    end,

    getZRotationDisplayValues = function()
        local results = {}
        for i = -privateValues.zRotationMaxIndex, privateValues.zRotationMaxIndex, 1 do
            results[#results + 1] = ("%.2g °"):format(i / privateValues.zRotationMaxIndex * 90)
        end
        return results
    end,

    getZShiftActualValues = function()
        local results = {}
        for _, plh in pairs(_platformHeightsSorted) do
            results[#results + 1] = plh.aboveGround - constants.defaultPlatformHeight
        end
        return results
    end,

    getZShiftDisplayValues = function()
        local results = {}
        for _, plh in pairs(_platformHeightsSorted) do
            results[#results + 1] = ("%.3g m"):format(plh.aboveRail)
        end
        return results
    end,

    getModels = function(isWallTall)
        local results = {}
        local add = function(modelFileName, iconFileName, name)
            results[#results + 1] = {
                fileName = modelFileName,
                icon = iconFileName,
                -- id = id,
                name = name
            }
        end
        if isWallTall then
            add(nil, 'ui/none.tga', _('NoWallName'))
            add('platformWalls/tiled/platformWall_5m.mdl', 'ui/wallTiled.tga', _("WallTiledName"))
        else
            add(nil, 'ui/none.tga', _('NoWallName'))
            add('platformWalls/tiled/platformWall_low_5m.mdl', 'ui/wallTiled.tga', _("WallTiledName"))
        end
        return results
    end,
    getWallBehindModels = function(isWallTall)
        local results = {}
        local add = function(modelFileName, iconFileName, name)
            results[#results + 1] = {
                fileName = modelFileName,
                icon = iconFileName,
                -- id = id,
                name = name
            }
        end
        if isWallTall then
            add(nil, 'ui/none.tga', _('NoWallName'))
            add('platformWalls/behind/tunnely_wall_5m.mdl', 'ui/wallBehindTunnely.tga', _('WallTunnelyName'))
        else
            add(nil, 'ui/none.tga', _('NoWallName'))
            add('platformWalls/behind/tunnely_wall_low_5m.mdl', 'ui/wallBehindTunnely.tga', _('WallTunnelyName'))
        end
        return results
    end,
}

return {
    getModels = function(isTunnel)
        return privateFuncs.getModels(isTunnel)
    end,
    getWallBehindModels = function(isTunnel)
        return privateFuncs.getWallBehindModels(isTunnel)
    end,
    getConParams = function ()
        local models = privateFuncs.getModels()
        local wallBehindModels = privateFuncs.getWallBehindModels()
        return {
            {
                defaultIndex = privateValues.defaults.ouestFenceAssets_model,
                key = 'ouestFenceAssets_model',
                name = _('fenceModelName'),
                values = arrayUtils.map(
                        models,
                        function(model)
                            -- return model.name
                            return model.icon
                        end
                ),
                uiType = 'ICON_BUTTON',
            },
            {
                defaultIndex = privateValues.defaults.ouestFenceAssets_wallEraPrefix,
                key = 'ouestFenceAssets_wallEraPrefix',
                name = _('wallEraPrefix_0IsNoWall'),
                uiType = 'BUTTON',
                values = {_('NoWall'), 'C'},
            },
            {
                defaultIndex = privateValues.defaults.ouestFenceAssets_wallBehindModel,
                key = 'ouestFenceAssets_wallBehindModel',
                name = _('wallBehindModel_0IsNoWall'),
                values = arrayUtils.map(
                        wallBehindModels,
                        function(model)
                            -- return model.name
                            return model.icon
                        end
                ),
                uiType = 'ICON_BUTTON',
            },
            {
                defaultIndex = privateValues.defaults.ouestFenceAssets_doTerrain,
                key = 'ouestFenceAssets_doTerrain',
                name = _('DoTerrain'),
                uiType = 'BUTTON',
                values = {_('NO'), _('YES')}
            },
            {
                defaultIndex = privateValues.defaults.ouestFenceAssets_length,
                key = 'ouestFenceAssets_length',
                name = _('Length'),
                uiType = 'SLIDER',
                values = privateFuncs.getLengthValues(),
            },
            {
                defaultIndex = privateValues.defaults.ouestFenceAssets_yShift,
                key = 'ouestFenceAssets_yShift',
                name = _('YShift'),
                uiType = 'SLIDER',
                values = privateFuncs.getYShiftDisplayValues(),
            },
            {
                defaultIndex = privateValues.defaults.ouestFenceAssets_yShiftFine,
                key = 'ouestFenceAssets_yShiftFine',
                name = _('YShiftFine'),
                uiType = 'SLIDER',
                values = privateFuncs.getYShiftFineDisplayValues(),
            },
            {
                defaultIndex = privateValues.defaults.ouestFenceAssets_zRotation,
                key = 'ouestFenceAssets_zRotation',
                name = _('ZRotation'),
                uiType = 'SLIDER',
                values = privateFuncs.getZRotationDisplayValues(),
            },
            {
                defaultIndex = privateValues.defaults.ouestFenceAssets_zDelta,
                key = 'ouestFenceAssets_zDelta',
                name = _('ZDelta'),
                uiType = 'SLIDER',
                values = privateFuncs.getZDeltaDisplayValues(),
            },
            {
                defaultIndex = privateValues.defaults.ouestFenceAssets_zShift,
                key = 'ouestFenceAssets_zShift',
                name = _('ZShift'),
                uiType = 'BUTTON',
                values = privateFuncs.getZShiftDisplayValues(),
            },
            {
                defaultIndex = privateValues.defaults.ouestFenceAssets_isWallTall,
                key = 'ouestFenceAssets_isWallTall',
                name = _('IsWallTall'),
                uiType = 'BUTTON',
                values = {_('NO'), _('YES')}
            },
        }
    end,
    getChangeableParamsMetadata = function()
        local models = privateFuncs.getModels()
        local wallBehindModels = privateFuncs.getWallBehindModels()
        local metadata_sorted = {
            {
                defaultIndex = privateValues.defaults.ouestFenceAssets_model,
                key = 'ouestFenceAssets_model',
                name = _('fenceModelName'),
                values = arrayUtils.map(
                        models,
                        function(model)
                            -- return model.name
                            return model.icon
                        end
                ),
                uiType = 'ICON_BUTTON',
            },
            {
                defaultIndex = privateValues.defaults.ouestFenceAssets_wallEraPrefix,
                key = 'ouestFenceAssets_wallEraPrefix',
                name = _('wallEraPrefix_0IsNoWall'),
                uiType = 'BUTTON',
                values = {_('NoWall'), 'C'},
            },
            {
                defaultIndex = privateValues.defaults.ouestFenceAssets_wallBehindModel,
                key = 'ouestFenceAssets_wallBehindModel',
                name = _('wallBehindModel_0IsNoWall'),
                values = arrayUtils.map(
                        wallBehindModels,
                        function(model)
                            -- return model.name
                            return model.icon
                        end
                ),
                uiType = 'ICON_BUTTON',
            },
            {
                defaultIndex = privateValues.defaults.ouestFenceAssets_wallBehindOnBridges,
                key = 'ouestFenceAssets_wallBehindOnBridges',
                name = _('wallBehind_isOnBridges'),
                uiType = 'CHECKBOX',
                values = {_('NO'), _('YES')}
            },
            {
                defaultIndex = privateValues.defaults.ouestFenceAssets_wallBehindInTunnels,
                key = 'ouestFenceAssets_wallBehindInTunnels',
                name = _('wallBehind_isInTunnels'),
                uiType = 'CHECKBOX',
                values = {_('NO'), _('YES')}
            },
            {
                defaultIndex = privateValues.defaults.ouestFenceAssets_doTerrain,
                key = 'ouestFenceAssets_doTerrain',
                name = _('DoTerrain'),
                uiType = 'CHECKBOX',
                values = {_('NO'), _('YES')}
            },
            {
                defaultIndex = privateValues.defaults.ouestFenceAssets_yShiftFine,
                key = 'ouestFenceAssets_yShiftFine',
                name = _('YShift'),
                uiType = 'SLIDER',
                values = privateFuncs.getYShiftFineDisplayValues(),
            },
            {
                defaultIndex = privateValues.defaults.ouestFenceAssets_zShift,
                key = 'ouestFenceAssets_zShift',
                name = _('ZShift'),
                uiType = 'BUTTON',
                values = privateFuncs.getZShiftDisplayValues(),
            },
            -- there is no way yet to accurately find out if an edge is frozen without the api:
            -- I often add or remove one metre, unless I rewrite getCentralEdgePositions_OnlyOuterBounds
            -- {
            --     defaultIndex = privateValues.defaults.lolloFenceAssets_buildOnFrozenEdges,
            --     key = 'lolloFenceAssets_buildOnFrozenEdges',
            --     name = _('BuildOnStations'),
            --     uiType = 'CHECKBOX',
            --     values = {_('NO'), _('YES')}
            -- },
        }
        -- add defaultIndex wherever not present
        for _, record in pairs(metadata_sorted) do
            record.defaultIndex = record.defaultIndex or 0
        end
        local metadata_indexed = {}
        for _, record in pairs(metadata_sorted) do
            metadata_indexed[record.key] = record
        end
        -- logger.print('metadata_sorted =') logger.debugPrint(metadata_sorted)
        -- logger.print('metadata_indexed =') logger.debugPrint(metadata_indexed)
        return metadata_sorted, metadata_indexed
    end,
    getUiTypeNumber = function(uiTypeStr)
        if uiTypeStr == 'BUTTON' then return 0
        elseif uiTypeStr == 'SLIDER' then return 1
        elseif uiTypeStr == 'COMBOBOX' then return 2
        elseif uiTypeStr == 'ICON_BUTTON' then return 3 -- double-check this
        elseif uiTypeStr == 'CHECKBOX' then return 4 -- double-check this
        else return 0
        end
    end,
    getYShiftActualValues = function()
        return privateFuncs.getYShiftActualValues()
    end,
    getYShiftFineActualValues = function()
        return privateFuncs.getYShiftFineActualValues()
    end,
    getZDeltaActualValues = function()
        return privateFuncs.getZDeltaActualValues()
    end,
    getZRotationActualValues = function()
        return privateFuncs.getZRotationActualValues()
    end,
    getZShiftActualValues = function()
        return privateFuncs.getZShiftActualValues()
    end,
    getDefaultIndexes = function()
        return privateValues.defaults
    end
    -- getConstants = function()
    --     return privateValues
    -- end,
}