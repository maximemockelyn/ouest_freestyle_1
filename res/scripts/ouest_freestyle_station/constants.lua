local arrayUtils = require('ouest_freestyle_station.arrayUtils')

local constants = {
    invisiblePlatformTracksCategory = 'invisible-platform-tracks',
    passengerPlatformTracksCategory = 'passenger-platform-tracks',
    trainTracksCategory = 'train-tracks',

    eventData = {
        autoFence = {
            eventId = '__autoFence__',
            eventNames = {
                BULLDOZE_CON_REQUESTED = 'bulldozeConRequested',
                CON_PARAMS_UPDATED = 'conParamsUpdated',
                FENCE_WAYPOINTS_BUILT = 'fenceWaypointsBuilt',
                WAYPOINT_BULLDOZE_REQUESTED = 'waypointBulldozeRequested',
            },
        },
        eventId = 'freestyleTrainStation',
        eventNames = {
            ALLOW_PROGRESS = 'ALLOW_PROGRESS',
            BUILD_SNAPPY_STREET_EDGES_REQUESTED = 'BUILD_SNAPPY_STREET_EDGES_REQUESTED',
            BUILD_STATION_REQUESTED = 'BUILD_STATION_REQUESTED',
            BULLDOZE_MARKER_REQUESTED = 'BULLDOZE_MARKER_REQUESTED',
            BULLDOZE_STATION_REQUESTED = 'BULLDOZE_STATION_REQUESTED',
            CON_CONFIG_MENU_CLOSED = 'CON_CONFIG_MENU_CLOSED',
            CON_CONFIG_MENU_OPENED = 'CON_CONFIG_MENU_OPENED',
            HIDE_HOLE_REQUESTED = 'HIDE_HOLE_REQUESTED',
            HIDE_PROGRESS = 'HIDE_PROGRESS',
            HIDE_WARNINGS = 'HIDE_WARNINGS',
            PLATFORM_MARKER_BUILT = 'PLATFORM_MARKER_BUILT',
            PLATFORM_WAYPOINT_1_SPLIT_REQUESTED = 'PLATFORM_WAYPOINT_1_SPLIT_REQUESTED',
            PLATFORM_WAYPOINT_2_SPLIT_REQUESTED = 'PLATFORM_WAYPOINT_2_SPLIT_REQUESTED',
            REBUILD_NEIGHBOUR_CONS = 'REBUILD_NEIGHBOUR_CONS',
            REBUILD_NEIGHBOURS_ALL = 'REBUILD_NEIGHBOURS_ALL',
            REBUILD_STATION_WITH_LATEST_PROPERTIES = 'REBUILD_STATION_WITH_LATEST_PROPERTIES',
            SPLITTER_WAYPOINT_PLACED = 'SPLITTER_WAYPOINT_PLACED',
            SUBWAY_JOIN_REQUESTED = 'SUBWAY_JOIN_REQUESTED',
            SUBWAY_BUILD = 'SUBWAY_BUILD',
            TRACK_BULLDOZE_REQUESTED = 'TRACK_BULLDOZE_REQUESTED',
            TRACK_SPLIT_REQUESTED = 'TRACK_SPLIT_REQUESTED',
            TRACK_WAYPOINT_1_SPLIT_REQUESTED = 'TRACK_WAYPOINT_1_SPLIT_REQUESTED',
            TRACK_WAYPOINT_2_SPLIT_REQUESTED = 'TRACK_WAYPOINT_2_SPLIT_REQUESTED',
            UPGRADE_NEIGHBOUR_CONS = 'UPGRADE_NEIGHBOUR_CONS',
            WAYPOINT_BULLDOZE_REQUESTED = 'WAYPOINT_BULLDOZE_REQUESTED',
        },
    },
    stairsAndRampHeight = 0.55,
    defaultPlatformHeight = 0.55,
    platformHeights = {
        _0cm = {aboveRail = 0.0, aboveGround = 0.40, isOnlyCargo = true, moduleFileName = 'station/rail/platformHeights/platformHeight0.module',},
        _55cm = {aboveRail = 0.55, aboveGround = 0.95, moduleFileName = 'station/rail/platformHeights/platformHeight55.module',},
        _76cm = {aboveRail = 0.76, aboveGround = 1.16, moduleFileName = 'station/rail/platformHeights/platformHeight76.module',},
        _92cm = {aboveRail = 0.92, aboveGround = 1.32, moduleFileName = 'station/rail/platformHeights/platformHeight92.module',},
    },
    passengersPlatformStyles = {
        era_c = {moduleFileName = 'station/rail/platformStyles/platformStyleType1EraC.module'},
        era_c_type_1_1_stripe = {moduleFileName = 'station/rail/platformStyles/platformType1Stripe1EraC.module'},
        era_c_type_1_2_stripe = {moduleFileName = 'station/rail/platformStyles/platformType1Stripe2EraC.module'},
    },

    platformSideBitsZ = -0.10, -- a bit lower than the platform, to look good in bends
    platformRoofZ = -0.20, -- a bit lower than the platform, to look good on slopes
    underpassZ = -4, -- must be negative and different from the lift heights (5, 10, 15 etc)
    underpassLengthM = 1, -- don't change this, it must stay 1
    tunnelStairsUpZ = 7, -- was 4, which is too little, 7 is barely enough
    subwayPos2LinkX = 4,
    subwayPos2LinkY = 0,
    subwayPos2LinkZ = -4,
    openStairsUpZ = 8,
    trackCrossingZ = 0.45,
    trackCrossingRaise = 0.25,

    stairsEdgeSpacing = {-0.1, 0.4, 0.4, 0.4},
    maxAbsoluteDeviation4Midpoint = 5,
    maxPassengerWaitingAreaEdgeLength = 10,
    fineSegmentLength = 1,
    minLinkLength = 0.101,
    minLinkLength_power2 = 0.101 * 0.101,
    railEdgeType = 1, -- 0 = ROAD, 1 = RAIL
    streetEdgeType = 0, -- 0 = ROAD, 1 = RAIL
    maxNTerminals = 12,
    minSplitDistance = 2,
    minSplitDistanceAtEndOfLine = 3,
    maxFenceWaypointDistance = 1020,
    maxWaypointDistance = 1020,
    minWaypointDistance = 20,
    searchRadius4NearbyStation2Join = 500,
    slopeHigh = 999,
    slopeLow = 2.5,

    splitterZShift = 0,
    splitterZToleranceM = 1, -- must be positive

    eras = {
        era_c = { prefix = 'era_c_', startYear = 1980 },
    },

    era_c_groundFacesFillKey = 'ouest_train_station/asphalt_02_high_priority.lua', -- 'shared/asphalt_02.gtex.lua',
    earth_groundFacesFillKey = 'ouest_train_station/earth_high_priority.lua',
    gravel_groundFacesFillKey = 'ballast.lua',
    era_a_groundFacesStrokeOuterKey = 'ouest_train_station/gravel_03_high_priority.lua',
    era_b_groundFacesStrokeOuterKey = 'ouest_train_station/asphalt_01_high_priority.lua',
    era_c_groundFacesStrokeOuterKey = 'ouest_train_station/asphalt_02_high_priority.lua',

    autoFenceConFileName = 'auto_fence.con',
    platformMarkerConName = 'station/rail/platform_marker.con',
    stationConFileName = 'station/rail/station.con',

    edgeModuleFileNames = {
        fake = {
            axialArea = 'station/rail/axialAreas/flatPassengerStairsFakeEdge.module',
            flatArea = 'station/rail/flatAreas/flatPassengerStairsFakeEdge.module',
            openStairs = 'station/rail/openStairs/openStairsExitWithFakeEdge_2m_v2.module'
        },
        plain = {
            axialArea = 'station/rail/axialAreas/flatPassengerStairsEdge.module',
            flatArea = 'station/rail/flatAreas/flatPassengerStairsEdge.module',
            openStairs = 'station/rail/openStairs/openStairsExitWithEdge_2m_v2.module'
        },
        snappy = {
            axialArea = 'station/rail/axialAreas/flatPassengerStairsSnappyEdge.module',
            flatArea = 'station/rail/flatAreas/flatPassengerStairsSnappyEdge.module',
            openStairs = 'station/rail/openStairs/openStairsExitWithSnappyEdge_2m_v2.module'
        },
    },

    axialFlushPassengerExitModuleType = 'ouestTrainStationAxialFlushPassengerExit',
    axialPassengerEdgeModuleType = 'ouestTrainStationAxialPassengerEdge',
    axialPassengerExitModuleType = 'ouestTrainStationAxialPassengerExit',
    flatPassengerStairsModuleType = 'ouestTrainStationFlatPassengerStairs',
    flatPassengerEdgeModuleType = 'ouestTrainStationFlatPassengerEdge',
    flatPassengerArea5x5ModuleType = 'ouestTrainStationFlatPassengerArea5x5',
    flatPassengerArea8x5ModuleType = 'ouestTrainStationFlatPassengerArea8x5',
    flatPassengerArea8x10ModuleType = 'ouestTrainStationFlatPassengerArea8x10',
    flatPassengerStation0MModuleType = 'ouestTrainStationFlatPassengerStation0M',
    flatPassengerStation5MModuleType = 'ouestTrainStationFlatPassengerStation5M',
    flushPassengerExitModuleType = 'ouestTrainStationFlushExit',
    passengerSideLiftModuleType = 'ouestTrainStationPassengerSideLift',
    passengerPlatformLiftModuleType = 'ouestTrainStationPassengerPlatformLift',
    passengerStationSquareModuleType = 'ouestTrainStationPassengerStationSquare',
    passengersPlatformHeadModuleType = 'ouestTrainStationPassengersPlatformHead',
    slopedPassengerArea1x2_5ModuleType = 'ouestTrainStationSlopedPassengerArea1x2_5',
    slopedPassengerArea1x5ModuleType = 'ouestTrainStationSlopedPassengerArea1x5',
    slopedPassengerArea1x10ModuleType = 'ouestTrainStationSlopedPassengerArea1x10',
    slopedPassengerArea1x20ModuleType = 'ouestTrainStationSlopedPassengerArea1x20',
    passengerTerminalModuleType = 'ouestTrainStationPassengerTerminal',
    restorePassengerTerminalModuleType = 'ouestTrainStationRestorePassengerTerminal',
    platformHeightModuleType = 'ouestTrainStationPlatformHeight',
    passengersPlatformStyleModuleType = 'ouestTrainStationPassengersPlatformStyle',
    era_c_platformModuleType = 'ouestTrainStationPlatformEraC',
    underpassModuleType = 'ouestTrainStationUnderpass',
    trackSpeedModuleType = 'ouestTrainStationTrackSpeed',
    trackElectrificationModuleType = 'ouestTrainStationTrackElectrification',
    openLiftModuleType = 'ouestTrainStationOpenLift',
    openStairsUpLeftModuleType = 'ouestTrainStationOpenStairsUpLeft',
    openStairsUpRightModuleType = 'ouestTrainStationOpenStairsUpRight',
    openStairsExitModuleType = 'ouestTrainStationOpenStairsExit',
    trackTypeModuleType = 'ouestTrainStationTrackTypeModuleType',
    platformWallModuleType = 'freestyleTrainStationWall',
    trackWallModuleType = 'freestyleTrainStationTrackWall',

    era_c_flatPassengerStairsDownSmoothModelFileName = 'ouest_train_station/railroad/flatSides/passengers/stairs_down_smooth.mdl',
    era_c_flatPassengerStairsDownSteepModelFileName = 'ouest_train_station/railroad/flatSides/passengers/stairs_down_steep.mdl',
    era_c_flatPassengerStairsFlatModelFileName = 'ouest_train_station/railroad/flatSides/passengers/stairs_flat.mdl',
    era_c_flatPassengerStairsUpSmoothModelFileName = 'ouest_train_station/railroad/flatSides/passengers/stairs_up_smooth.mdl',
    era_c_flatPassengerStairsUpSteepModelFileName = 'ouest_train_station/railroad/flatSides/passengers/stairs_up_steep.mdl',
    era_c_flatPassengerArea5x5ModelFileName = 'ouest_train_station/railroad/flatSides/passengers/area5x5.mdl',
    era_c_flatPassengerArea8x5ModelFileName = 'ouest_train_station/railroad/flatSides/passengers/area8x5.mdl',
    era_c_flatPassengerArea8x10ModelFileName = 'ouest_train_station/railroad/flatSides/passengers/area8x10.mdl',

    era_c_slopedPassengerArea1x2_5ModelFileName = 'ouest_train_station/railroad/slopedSides/passengers/area1x2_5.mdl',
    era_c_slopedPassengerArea1x5ModelFileName = 'ouest_train_station/railroad/slopedSides/passengers/area1x5.mdl',
    era_c_slopedPassengerArea1x10ModelFileName = 'ouest_train_station/railroad/slopedSides/passengers/area1x10.mdl',
    era_c_slopedPassengerArea1x20ModelFileName = 'ouest_train_station/railroad/slopedSides/passengers/area1x20.mdl',

    terminalModelFileName = 'ouest_train_station/asset/terminal_signal.mdl',
    fenceWaypointModelId = 'ouest_train_station/railroad/fence_waypoint.mdl',
    platformWaypointModelId = 'ouest_train_station/railroad/platform_waypoint.mdl',
    splitterWaypointModelId = 'ouest_train_station/railroad/zzz_splitter_waypoint.mdl',
    trackWaypointModelId = 'ouest_train_station/railroad/track_waypoint.mdl',

    passengerWaitingAreaModelId = 'ouest_train_station/passenger_waiting_area.mdl',
    passengerWaitingAreaCentredModelFileName = 'ouest_train_station/passenger_waiting_area_centred.mdl',
    passengerLaneModelId = 'ouest_train_station/passenger_lane.mdl',
    passengerLaneLinkableModelId = 'ouest_train_station/passenger_lane_linkable.mdl',

    redHugeMessageModelFileName = 'ouest_train_station/icon/red_huge_w_message.mdl',
    redMessageModelFileName = 'ouest_train_station/icon/red_w_message.mdl',
    yellowMessageModelFileName = 'ouest_train_station/icon/yellow_w_message.mdl',
    emptyModelFileName = 'ouest_train_station/empty.mdl',

    openLiftModuleFileName = 'station/rail/ouest_train_station/openLifts/openLift.module',
    openLift_NoAutoLink_ModuleFileName = 'station/rail/ouest_train_station/openLifts/openLift_NoAutoLink_v2.module',
    openStairsUpLeftModuleFileName = 'station/rail/ouest_train_station/openStairs/openStairsUpLeft.module',
    openStairsUpLeft_NoAutoLink_ModuleFileName = 'station/rail/ouest_train_station/openStairs/openStairsUpLeft_NoAutoLink.module',
    openStairsUpRightModuleFileName = 'station/rail/ouest_train_station/openStairs/openStairsUpRight.module',
    openStairsUpRight_NoAutoLink_ModuleFileName = 'station/rail/ouest_train_station/openStairs/openStairsUpRight_NoAutoLink.module',
    restorePassengerTerminalModuleFileName = 'station/rail/ouest_train_station/restorePassengerTerminal.module',
    passengerTerminalModuleFileName = 'station/rail/ouest_train_station/passengerTerminal.module',
    trackSpeedSlowModuleFileName = 'station/rail/ouest_train_station/trackSpeedSlow.module',
    trackSpeedFastModuleFileName = 'station/rail/ouest_train_station/trackSpeedFast.module',
    trackSpeedUndefinedModuleFileName = 'station/rail/ouest_train_station/trackSpeedUndefined.module',
    trackElectrificationNoModuleFileName = 'station/rail/ouest_train_station/trackElectrificationNo.module',
    trackElectrificationYesModuleFileName = 'station/rail/ouest_train_station/trackElectrificationYes.module',
    trackElectrificationUndefinedModuleFileName = 'station/rail/ouest_train_station/trackElectrificationUndefined.module',

    passengersWaitingAreaTagRoot = 'passengersWaitingArea_',
    passengersWaitingAreaUnderpassTagRoot = 'passengersWaitingAreaUnderpass_',

    stationPassengerTag = 2,

    nTerminalMultiplier = 10000,
    idBases = {
        terminalSlotId = 1000000,
        restorePassengerTerminalSlotId = 3000000,
        platformHeightSlotId = 4000000,
        platformStyleSlotId = 5000000,
        platformHeadSlotId = 6000000,
        trackCrossingSlotId = 11000000,
        flatStairsOrRampSlotId = 12000000,
        flatArea5x5SlotId = 13000000,
        flatArea8x5SlotId = 14000000,
        flatArea8x10SlotId = 15000000,
        flatPassengerEdgeSlotId = 16000000,
        axialEdgeSlotId = 17000000,
        flatStation0MSlotId = 21000000,
        flatStation5MSlotId = 22000000,
        sideLiftSlotId = 23000000,
        platformLiftSlotId = 24000000,
        passengerStationSquareOuterSlotId = 25000000,
        passengerStationSquareInnerSlotId = 26000000,
        slopedArea1x5SlotId = 31000000,
        slopedArea1x10SlotId = 32000000,
        slopedArea1x20SlotId = 33000000,
        slopedArea1x2_5SlotId = 34000000,
        underpassSlotId = 40000000,
        tunnelStairsUpSlotId = 50000000,
        subwaySlotId = 51000000,
        tunnelStairsUpDownSlotId = 52000000,
        openStairsUpRightSlotId = 53000000,
        openStairsUpLeftSlotId = 54000000,
        openStairsExitOuterSlotId = 55000000,
        openStairsExitInnerSlotId = 56000000,
        openLiftSlotId = 57000000,
        openLiftExitOuterSlotId = 58000000,
        openLiftExitInnerSlotId = 59000000,
        trackElectrificationSlotId = 60000000,
        trackSpeedSlotId = 61000000,
        trackTypeSlotId = 62000000,
        bridgeTypeSlotId = 63000000,
        tunnelTypeSlotId = 64000000,
        platformRoofSlotId = 70000000,
        platformWallSlotId = 71000000,
        trackWallSlotId = 72000000,
        axialWallSlotId = 73000000,
        platformEraASlotId = 80000000,
        platformEraBSlotId = 81000000,
        platformEraCSlotId = 82000000,
        openStairsExitCentreSlotId = 90000000,
        openLiftExitForwardSlotId = 91000000,
        openLiftExitBackwardSlotId = 92000000,
        flushExitSlotId = 93000000,
        cargoShelfSlotId = 94000000,
        axialFlushExitSlotId = 95000000,
        axialStairsOrRampSlotId = 96000000,
        axialStation0MSlotId = 97000000,
        axialStation5MSlotId = 98000000,
    },
    idTransf = {
        1, 0, 0, 0,
        0, 1, 0, 0,
        0, 0, 1, 0,
        0, 0, 0, 1
    }
}

local idBasesSortedDesc = {}
for k, v in pairs(constants.idBases) do
    table.insert(idBasesSortedDesc, {id = v, name = k})
end
arrayUtils.sort(idBasesSortedDesc, 'id', false)
constants.idBasesSortedDesc = idBasesSortedDesc

return constants