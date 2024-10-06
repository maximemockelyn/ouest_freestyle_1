function data()
    local constants = require('ouest_freestyle_station.constants')
    local mdlHelpers = require('ouest_freestyle_station.mdlHelpers')
    local stringUtils = require('ouest_freestyle_station.stringUtils')
    local trackHelpers = require('ouest_freestyle_station.trackHelpers')

    return {
        info = {
            minorVersion = 1, -- Version mineure
            severityAdd = "NONE", -- Définit l'importance des messages dans le gestionnaire de mods (NONE, WARNING, CRITICAL)
            severityRemove = "CRITICAL", -- Ce qui se passe quand on retire le mod
            name = _("NAME_MOD"), -- Nom du mod, défini dans le fichier strings.lua pour la localisation
            description = _("DESC_MOD"), -- Description également dans le fichier strings.lua
            authors = {
                {
                    name = "Syltheron", -- Ton pseudo ou ton nom
                    role = "CREATOR", -- Ton rôle (CREATOR, ARTIST, PROGRAMMER, etc.)
                },
                {
                    name = "NTH-Z6K4", -- Ton pseudo ou ton nom
                    role = "CREATOR", -- Ton rôle (CREATOR, ARTIST, PROGRAMMER, etc.)
                },
                {
                    name = "Yoodel22", -- Ton pseudo ou ton nom
                    role = "CREATOR", -- Ton rôle (CREATOR, ARTIST, PROGRAMMER, etc.)
                },
            },
            tags = { "Station", "Modulaire", "Train" }, -- Des tags pour catégoriser ton mod
            visible = true,
        },

        runFn = function(settings)
            addModifier(
                    'loadModel',
                    function(fileName, data)
                        if not (stringUtils.stringEndsWith(fileName, '.mdl')) then
                            return
                        end

                        if data and data.metadata and data.metadata.streetTerminal then
                            data.boundingInfo = mdlHelpers.getVoidBoundingInfo()
                            data.collider = mdlHelpers.getVoidCollider()
                        end
                        return data
                    end
            )
        end,

        postRunFn = function(settings, params)
            local platformFileNames = {}
            local trackFileNames = api.res.trackTypeRep.getAll()
            for trackTypeIndex, trackFileName in pairs(trackFileNames) do
                local track = api.res.trackTypeRep.get(trackTypeIndex)
                if _trackHelpers.isPlatform2(track) then
                    platformFileNames[#platformFileNames + 1] = trackFileName
                else
                    trackHelpers.addCategory(track, _constants.trainTracksCategory)
                end
            end

            local moduleNames = api.res.moduleRep.getAll()
            for moduleIndex, moduleName in pairs(moduleNames) do
                if stringUtils.stringStartWith(moduleName, 'oueststation_') then
                    for _,platformFileName in pairs(moduleNames) do
                        if _stringUtils.stringContains(moduleName, platformFileName) then
                            api.res.moduleRep.setVisible(moduleIndex, false)
                            break
                        end
                    end
                end
            end

            local barredTrackFileNameBits = {
                'ballast_standard',
            }

            local isStringContainsAny = function(str, list)
                for _, item in pairs(list) do
                    if stringUtils.stringContains(str, item) then
                        return true
                    end
                end
                return false
            end

            for trackTypeIndex, trackFileName in pairs(trackFileNames) do
                if trackFileName ~= "standard.lua"
                        and trackFileName ~= "high_speed.lua"
                        and type(trackTypeIndex) == 'number'
                        and trackTypeIndex > -1
                        and api.res.trackTypeRep.isVisible(trackTypeIndex)
                        and type(trackFileName) == 'string'
                        and not(isStringContainsAny(trackFileName, barredTrackFileNameBits)) then

                    local track = api.res.trackTypeRep.get(trackTypeIndex)
                    if track ~= nil and not(trackHelpers.isPlatform2(track)) and track.name ~= nil and track.desc ~= nil and track.icon ~= nil then
                        for __, catenary in pairs({false,true}) do
                            local module = api.res.ModuleDesc.new()
                            module.filename = 'station/rail/ouest_train_station/trackTypes/dynamic_'..(catenary and "catenary_" or "") .. tostring(trackFileName) .. '.module'

                            module.availability.yearFrom = track.yearFrom
                            module.availability.yearTo = track.yearTo
                            module.cost.price = math.floor(track.cost / 75 * 18000 + 0.5)

                            module.description.name = track.name .. (catenary and _(" with catenary") or "")
                            module.description.description = track.desc .. (catenary and _(" (with catenary)") or "")
                            module.description.icon = track.icon
                            module.type = constants.trackTypeModuleType
                            module.order.value = 10 + 10 * (catenary and 1 or 0)
                            module.category.categories = { "track-type", }

                            module.updateScript.fileName = 'construction/station/rail/ouest_train_station/trackTypes/dynamic.updateFn'
                            module.updateScript.params = {
                                trackType = trackFileName,
                                catenary = catenary
                            }

                            module.getModelsScript.fileName = 'construction/station/rail/ouest_train_station/trackTypes/dynamic.getModelsFn'
                            module.getModelsScript.params = {
                                trackType = trackFileName,
                                catenary = catenary
                            }

                            api.res.moduleRep.add(module.fileName, module, true)
                        end
                    end
                end
            end
        end
    }
end
