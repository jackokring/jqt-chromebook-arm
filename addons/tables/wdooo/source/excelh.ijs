NB. =========================================================
NB. Office 2003

coclass 'excelh'

NB. AddinClientTypeEnum

ssCoerceBool=: 4
ssCoerceErr=: 16
ssCoerceFlow=: 32
ssCoerceFLStr=: 4096
ssCoerceFSRef=: 1024
ssCoerceInt=: 2048
ssCoerceMissing=: 128
ssCoerceMulti=: 64
ssCoerceNil=: 256
ssCoerceNum=: 1
ssCoerceParse=: 16384
ssCoerceRef=: 8
ssCoerceRef3d=: 512
ssCoerceSemiCalced=: 8192
ssCoerceStr=: 2
ssCoerceUncalced=: 32768

NB. BindingLoadMode

Delay=: 2
Normal=: 0
OM=: 1

NB. Chart3DSurfaceEnum

chSurfaceBackWall=: 0
chSurfaceFloor=: 2
chSurfaceSideWall=: 1

NB. ChartAxisCrossesEnum

chAxisCrossesAutomatic=: 0
chAxisCrossesCustom=: 3

NB. ChartAxisGroupingEnum

chAxisGroupingAuto=: 1
chAxisGroupingManual=: 2
chAxisGroupingNone=: 0

NB. ChartAxisPositionEnum

chAxisPositionBottom=: _2
chAxisPositionCategory=: _7
chAxisPositionCircular=: _6
chAxisPositionLeft=: _3
chAxisPositionPrimary=: _10
chAxisPositionRadial=: _5
chAxisPositionRight=: _4
chAxisPositionSecondary=: _11
chAxisPositionSeries=: _9
chAxisPositionTimescale=: _7
chAxisPositionTop=: _1
chAxisPositionValue=: _8

NB. ChartAxisTypeEnum

chCategoryAxis=: 0
chSeriesAxis=: 3
chTimescaleAxis=: 2
chValueAxis=: 1

NB. ChartAxisUnitTypeEnum

chAxisUnitDay=: 0
chAxisUnitMonth=: 2
chAxisUnitQuarter=: 3
chAxisUnitWeek=: 1
chAxisUnitYear=: 4

NB. ChartBoundaryValueTypeEnum

chBoundaryValueAbsolute=: 1
chBoundaryValuePercent=: 0

NB. ChartChartLayoutEnum

chChartLayoutAutomatic=: 0
chChartLayoutHorizontal=: 1
chChartLayoutVertical=: 2

NB. ChartChartTypeEnum

chChartTypeArea=: 29
chChartTypeArea3D=: 60
chChartTypeAreaOverlapped3D=: 61
chChartTypeAreaStacked=: 30
chChartTypeAreaStacked100=: 31
chChartTypeAreaStacked1003D=: 63
chChartTypeAreaStacked3D=: 62
chChartTypeBar3D=: 50
chChartTypeBarClustered=: 3
chChartTypeBarClustered3D=: 51
chChartTypeBarStacked=: 4
chChartTypeBarStacked100=: 5
chChartTypeBarStacked1003D=: 53
chChartTypeBarStacked3D=: 52
chChartTypeBubble=: 27
chChartTypeBubbleLine=: 28
chChartTypeColumn3D=: 46
chChartTypeColumnClustered=: 0
chChartTypeColumnClustered3D=: 47
chChartTypeColumnStacked=: 1
chChartTypeColumnStacked100=: 2
chChartTypeColumnStacked1003D=: 49
chChartTypeColumnStacked3D=: 48
chChartTypeCombo=: _1
chChartTypeCombo3D=: _2
chChartTypeDoughnut=: 32
chChartTypeDoughnutExploded=: 33
chChartTypeLine=: 6
chChartTypeLine3D=: 54
chChartTypeLineMarkers=: 7
chChartTypeLineOverlapped3D=: 55
chChartTypeLineStacked=: 8
chChartTypeLineStacked100=: 10
chChartTypeLineStacked1003D=: 57
chChartTypeLineStacked100Markers=: 11
chChartTypeLineStacked3D=: 56
chChartTypeLineStackedMarkers=: 9
chChartTypePie=: 18
chChartTypePie3D=: 58
chChartTypePieExploded=: 19
chChartTypePieExploded3D=: 59
chChartTypePieStacked=: 20
chChartTypePolarLine=: 42
chChartTypePolarLineMarkers=: 43
chChartTypePolarMarkers=: 41
chChartTypePolarSmoothLine=: 44
chChartTypePolarSmoothLineMarkers=: 45
chChartTypeRadarLine=: 34
chChartTypeRadarLineFilled=: 36
chChartTypeRadarLineMarkers=: 35
chChartTypeRadarSmoothLine=: 37
chChartTypeRadarSmoothLineMarkers=: 38
chChartTypeScatterLine=: 25
chChartTypeScatterLineFilled=: 26
chChartTypeScatterLineMarkers=: 24
chChartTypeScatterMarkers=: 21
chChartTypeScatterSmoothLine=: 23
chChartTypeScatterSmoothLineMarkers=: 22
chChartTypeSmoothLine=: 12
chChartTypeSmoothLineMarkers=: 13
chChartTypeSmoothLineStacked=: 14
chChartTypeSmoothLineStacked100=: 16
chChartTypeSmoothLineStacked100Markers=: 17
chChartTypeSmoothLineStackedMarkers=: 15
chChartTypeStockHLC=: 39
chChartTypeStockOHLC=: 40

NB. ChartColorIndexEnum

chColorAutomatic=: _1
chColorNone=: _2

NB. ChartCommandIdEnum

chCommandAutoCalc=: 1016
chCommandAutoFilter=: 1017
chCommandAverage=: 6045
chCommandBold=: 1052
chCommandByRowCol=: 6032
chCommandChartType=: 6039
chCommandCollapse=: 1013
chCommandConditionalFilter=: 1125
chCommandCount=: 6042
chCommandCut=: 1001
chCommandDeleteSelection=: 1011
chCommandDrill=: 6034
chCommandDrillOut=: 6037
chCommandExpand=: 1012
chCommandFieldList=: 1010
chCommandFilterByMenu=: 1015
chCommandFontColor=: 1057
chCommandFontName=: 1050
chCommandFontSize=: 1051
chCommandInteriorColor=: 1056
chCommandItalic=: 1053
chCommandLaunchDataFinder=: 6027
chCommandLineColor=: 1055
chCommandMax=: 6044
chCommandMin=: 6043
chCommandMoveToCategoryArea=: 6056
chCommandMoveToChartArea=: 6057
chCommandMoveToFilterArea=: 6054
chCommandMoveToSeriesArea=: 6055
chCommandMultiChart=: 6050
chCommandPassiveAlert=: 6026
chCommandRefresh=: 1014
chCommandSelectNextMajor=: 6005
chCommandSelectNextMinor=: 6003
chCommandSelectPrevMajor=: 6004
chCommandSelectPrevMinor=: 6002
chCommandShowAbout=: 1007
chCommandShowAll=: 1121
chCommandShowBottom1=: 1110
chCommandShowBottom10=: 1113
chCommandShowBottom10Percent=: 1118
chCommandShowBottom1Percent=: 1115
chCommandShowBottom2=: 1111
chCommandShowBottom25=: 1114
chCommandShowBottom25Percent=: 1119
chCommandShowBottom2Percent=: 1116
chCommandShowBottom5=: 1112
chCommandShowBottom5Percent=: 1117
chCommandShowBottomNMenu=: 1124
chCommandShowContextMenu=: 6001
chCommandShowDropZones=: 6052
chCommandShowHelp=: 1006
chCommandShowLegend=: 6028
chCommandShowOther=: 1120
chCommandShowPropertyToolbox=: 1005
chCommandShowToolbar=: 6053
chCommandShowTop1=: 1100
chCommandShowTop10=: 1103
chCommandShowTop10Percent=: 1108
chCommandShowTop1Percent=: 1105
chCommandShowTop2=: 1101
chCommandShowTop25=: 1104
chCommandShowTop25Percent=: 1109
chCommandShowTop2Percent=: 1106
chCommandShowTop5=: 1102
chCommandShowTop5Percent=: 1107
chCommandShowTopNMenu=: 1123
chCommandShowWizard=: 6040
chCommandSortAscending=: 2000
chCommandSortAscendingByTotal=: 6035
chCommandSortDescending=: 2031
chCommandSortDescendingByTotal=: 6036
chCommandStdDev=: 6046
chCommandStdDevP=: 6048
chCommandSum=: 6041
chCommandTogglePropertiesInScreenTip=: 6038
chCommandUnderline=: 1054
chCommandUndo=: 1000
chCommandUnifiedScales=: 6051
chCommandVar=: 6047
chCommandVarP=: 6049

NB. ChartDataGroupingFunctionEnum

chDataGroupingFunctionAverage=: 3
chDataGroupingFunctionMaximum=: 1
chDataGroupingFunctionMinimum=: 0
chDataGroupingFunctionSum=: 2

NB. ChartDataLabelPositionEnum

chLabelPositionAutomatic=: 0
chLabelPositionBottom=: 9
chLabelPositionCenter=: 1
chLabelPositionInsideBase=: 3
chLabelPositionInsideEnd=: 2
chLabelPositionLeft=: 6
chLabelPositionOutsideBase=: 5
chLabelPositionOutsideEnd=: 4
chLabelPositionRight=: 7
chLabelPositionTop=: 8

NB. ChartDataPointEnum

chDataPointFirst=: 0
chDataPointLast=: 1

NB. ChartDataSourceTypeEnum

chDataSourceTypeDSC=: 5
chDataSourceTypePivotTable=: 3
chDataSourceTypeQuery=: 4
chDataSourceTypeSpreadsheet=: 1
chDataSourceTypeUnknown=: 0

NB. ChartDimensionsEnum

chDimBubbleValues=: 9
chDimCategories=: 1
chDimCharts=: 15
chDimCloseValues=: 6
chDimFilter=: 14
chDimFormatValues=: 16
chDimHighValues=: 7
chDimLowValues=: 8
chDimOpenValues=: 5
chDimRValues=: 10
chDimSeriesNames=: 0
chDimThetaValues=: 11
chDimValues=: 2
chDimXValues=: 4
chDimYValues=: 3

NB. ChartDrawModesEnum

chDrawModeHitTest=: 3
chDrawModePaint=: 1
chDrawModeScale=: 4
chDrawModeSelection=: 2

NB. ChartDropZonesEnum

chDropZoneCategories=: 2
chDropZoneCharts=: 4
chDropZoneData=: 3
chDropZoneFilter=: 0
chDropZoneSeries=: 1

NB. ChartEndStyleEnum

chEndStyleCap=: 2
chEndStyleNone=: 1

NB. ChartErrorBarCustomValuesEnum

chErrorBarMinusValues=: 13
chErrorBarPlusValues=: 12

NB. ChartErrorBarDirectionEnum

chErrorBarDirectionX=: 1
chErrorBarDirectionY=: 0

NB. ChartErrorBarIncludeEnum

chErrorBarIncludeBoth=: 2
chErrorBarIncludeMinusValues=: 1
chErrorBarIncludePlusValues=: 0

NB. ChartErrorBarTypeEnum

chErrorBarTypeCustom=: 2
chErrorBarTypeFixedValue=: 0
chErrorBarTypePercent=: 1

NB. ChartFillStyleEnum

chNone=: _1
chSolid=: 0

NB. ChartFillTypeEnum

chFillGradientOneColor=: 3
chFillGradientPresetColors=: 5
chFillGradientTwoColors=: 4
chFillPatterned=: 2
chFillSolid=: 1
chFillTexturePreset=: 6
chFillTextureUserDefined=: 7

NB. ChartGradientStyleEnum

chGradientDiagonalDown=: 4
chGradientDiagonalUp=: 3
chGradientFromCenter=: 7
chGradientFromCorner=: 5
chGradientHorizontal=: 1
chGradientVertical=: 2

NB. ChartGradientVariantEnum

chGradientVariantCenter=: 3
chGradientVariantEdges=: 4
chGradientVariantEnd=: 2
chGradientVariantStart=: 1

NB. ChartGroupingTotalFunctionEnum

chFunctionAvg=: 5
chFunctionCount=: 2
chFunctionDefault=: 6
chFunctionMax=: 4
chFunctionMin=: 3
chFunctionSum=: 1

NB. ChartLabelOrientationEnum

chLabelOrientationAutomatic=: 1000
chLabelOrientationDownward=: _90
chLabelOrientationHorizontal=: 0
chLabelOrientationUpward=: 90

NB. ChartLegendPositionEnum

chLegendPositionAutomatic=: 0
chLegendPositionBottom=: 2
chLegendPositionLeft=: 3
chLegendPositionRight=: 4
chLegendPositionTop=: 1

NB. ChartLineDashStyleEnum

chLineDash=: 0
chLineDashDot=: 1
chLineDashDotDot=: 2
chLineLongDash=: 4
chLineLongDashDot=: 5
chLineRoundDot=: 6
chLineSolid=: 7
chLineSquareDot=: 8

NB. ChartLineMiterEnum

chLineMiterBevel=: 0
chLineMiterMiter=: 1
chLineMiterRound=: 2

NB. ChartMarkerStyleEnum

chMarkerStyleCircle=: 8
chMarkerStyleDash=: 7
chMarkerStyleDiamond=: 2
chMarkerStyleDot=: 6
chMarkerStyleNone=: 0
chMarkerStylePlus=: 9
chMarkerStyleSquare=: 1
chMarkerStyleStar=: 5
chMarkerStyleTriangle=: 3
chMarkerStyleX=: 4

NB. ChartPatternTypeEnum

chPattern10Percent=: 2
chPattern20Percent=: 3
chPattern25Percent=: 4
chPattern30Percent=: 5
chPattern40Percent=: 6
chPattern50Percent=: 7
chPattern5Percent=: 1
chPattern60Percent=: 8
chPattern70Percent=: 9
chPattern75Percent=: 10
chPattern80Percent=: 11
chPattern90Percent=: 12
chPatternDarkDownwardDiagonal=: 15
chPatternDarkHorizontal=: 13
chPatternDarkUpwardDiagonal=: 16
chPatternDarkVertical=: 14
chPatternDashedDownwardDiagonal=: 28
chPatternDashedHorizontal=: 32
chPatternDashedUpwardDiagonal=: 27
chPatternDashedVertical=: 31
chPatternDiagonalBrick=: 40
chPatternDivot=: 46
chPatternDottedDiamond=: 24
chPatternDottedGrid=: 45
chPatternHorizontalBrick=: 35
chPatternLargeCheckerBoard=: 36
chPatternLargeConfetti=: 33
chPatternLargeGrid=: 34
chPatternLightDownwardDiagonal=: 21
chPatternLightHorizontal=: 19
chPatternLightUpwardDiagonal=: 22
chPatternLightVertical=: 20
chPatternNarrowHorizontal=: 30
chPatternNarrowVertical=: 29
chPatternOutlinedDiamond=: 41
chPatternPlaid=: 42
chPatternShingle=: 47
chPatternSmallCheckerBoard=: 17
chPatternSmallConfetti=: 37
chPatternSmallGrid=: 23
chPatternSolidDiamond=: 39
chPatternSphere=: 43
chPatternTrellis=: 18
chPatternWave=: 48
chPatternWeave=: 44
chPatternWideDownwardDiagonal=: 25
chPatternWideUpwardDiagonal=: 26
chPatternZigZag=: 38

NB. ChartPivotDataReferenceEnum

chPivotColAggregates=: _3
chPivotColumns=: _1
chPivotRowAggregates=: _4
chPivotRows=: _2

NB. ChartPlotAggregatesEnum

chPlotAggregatesCategories=: 2
chPlotAggregatesCharts=: 3
chPlotAggregatesFromTotalOrientation=: 4
chPlotAggregatesNone=: 0
chPlotAggregatesSeries=: 1

NB. ChartPresetGradientTypeEnum

chGradientBrass=: 20
chGradientCalmWater=: 8
chGradientChrome=: 21
chGradientChromeII=: 22
chGradientDaybreak=: 4
chGradientDesert=: 6
chGradientEarlySunset=: 1
chGradientFire=: 9
chGradientFog=: 10
chGradientGold=: 18
chGradientGoldII=: 19
chGradientHorizon=: 5
chGradientLateSunset=: 2
chGradientMahogany=: 15
chGradientMoss=: 11
chGradientNightfall=: 3
chGradientOcean=: 7
chGradientParchment=: 14
chGradientPeacock=: 12
chGradientRainbow=: 16
chGradientRainbowII=: 17
chGradientSapphire=: 24
chGradientSilver=: 23
chGradientWheat=: 13

NB. ChartPresetTextureEnum

chTextureBlueTissuePaper=: 17
chTextureBouquet=: 20
chTextureBrownMarble=: 11
chTextureCanvas=: 2
chTextureCork=: 21
chTextureDenim=: 3
chTextureFishFossil=: 7
chTextureGranite=: 12
chTextureGreenMarble=: 9
chTextureMediumWood=: 24
chTextureNewsprint=: 13
chTextureOak=: 23
chTexturePaperBag=: 6
chTexturePapyrus=: 1
chTextureParchment=: 15
chTexturePinkTissuePaper=: 18
chTexturePurpleMesh=: 19
chTextureRecycledPaper=: 14
chTextureSand=: 8
chTextureStationery=: 16
chTextureWalnut=: 22
chTextureWaterDroplets=: 5
chTextureWhiteMarble=: 10
chTextureWovenMat=: 4

NB. ChartProjectionModeEnum

chProjectionModeOrthographic=: 1
chProjectionModePerspective=: 0

NB. ChartScaleOrientationEnum

chScaleOrientationMaxMin=: 1
chScaleOrientationMinMax=: 0

NB. ChartScaleTypeEnum

chScaleTypeLinear=: 0
chScaleTypeLogarithmic=: 1

NB. ChartSelectionMarksEnum

chSelectionMarksAll=: 1
chSelectionMarksNone=: 0
chSelectionMarksPivot=: 2

NB. ChartSelectionsEnum

chSelectionAxis=: 0
chSelectionCategoryLabel=: 16
chSelectionChart=: 1
chSelectionChartSpace=: 12
chSelectionDataLabel=: 18
chSelectionDataLabels=: 3
chSelectionDropZone=: 17
chSelectionErrorbars=: 4
chSelectionField=: 14
chSelectionGridlines=: 5
chSelectionLegend=: 6
chSelectionLegendEntry=: 7
chSelectionNone=: _1
chSelectionPlotArea=: 2
chSelectionPoint=: 8
chSelectionSeries=: 9
chSelectionSurface=: 13
chSelectionTitle=: 10
chSelectionTrendline=: 11
chSelectionUserDefined=: _2

NB. ChartSelectMode

chSelectModeAdd=: 1
chSelectModeRemove=: 2
chSelectModeReplace=: 0
chSelectModeToggle=: 3

NB. ChartSeriesByEnum

chSeriesByColumns=: 1
chSeriesByRows=: 0

NB. ChartSizeRepresentsEnum

chSizeIsArea=: 1
chSizeIsWidth=: 0

NB. ChartSpecialDataSourcesEnum

chDataBound=: 0
chDataLinked=: _3
chDataLiteral=: _1
chDataNone=: _2

NB. ChartTextureFormatEnum

chStack=: 1
chStackScale=: 2
chStretch=: 3
chStretchPlot=: 5
chTile=: 4

NB. ChartTexturePlacementEnum

chAllFaces=: 7
chEnd=: 2
chEndSides=: 6
chFront=: 1
chFrontEnd=: 3
chFrontSides=: 5
chProjectFront=: 8
chSides=: 4

NB. ChartTickMarkEnum

chTickMarkAutomatic=: 0
chTickMarkCross=: 4
chTickMarkInside=: 2
chTickMarkNone=: 1
chTickMarkOutside=: 3

NB. ChartTitlePositionEnum

chTitlePositionAutomatic=: 0
chTitlePositionBottom=: 2
chTitlePositionLeft=: 3
chTitlePositionRight=: 4
chTitlePositionTop=: 1

NB. ChartTrendlineTypeEnum

chTrendlineTypeExponential=: 0
chTrendlineTypeLinear=: 1
chTrendlineTypeLogarithmic=: 2
chTrendlineTypeMovingAverage=: 5
chTrendlineTypePolynomial=: 3
chTrendlineTypePower=: 4

NB. DefaultControlTypeEnum

ctlTypeBoundSpan=: 1
ctlTypeTextBox=: 0

NB. DscAdviseTypeEnum

dscAdd=: 1
dscChange=: 5
dscDelete=: 2
dscDeleteComplete=: 6
dscLoad=: 4
dscMove=: 3
dscRename=: 7

NB. DscDisplayAlert

dscDataAlertContinue=: 0
dscDataAlertDisplay=: 1

NB. DscDropLocationEnum

dscAbove=: 1
dscBelow=: 3
dscWithin=: 2

NB. DscDropTypeEnum

dscDefault=: 0
dscFields=: 2
dscGrid=: 1

NB. DscEncodingEnum

dscEUCJ=: 4
dscUCS2=: 2
dscUCS4=: 3
dscUTF16=: 1
dscUTF8=: 0
dscWindows=: 5

NB. DscFetchTypeEnum

dscFull=: 1
dscParameterized=: 2

NB. DscFieldTypeEnum

dscCalculated=: 2
dscGrouping=: 3
dscOutput=: 1
dscParameter=: _1

NB. DscGroupOnEnum

dscDay=: 6
dscEachValue=: 0
dscHour=: 7
dscInterval=: 9
dscMinute=: 8
dscMonth=: 4
dscPrefix=: 1
dscQuarter=: 3
dscWeek=: 5
dscYear=: 2

NB. DscHyperlinkPartEnum

dschlAddress=: 2
dschlDisplayedValue=: 0
dschlDisplayText=: 1
dschlFullAddress=: 5
dschlScreenTip=: 4
dschlSubAddress=: 3

NB. DscJoinTypeEnum

dscInnerJoin=: 1
dscLeftOuterJoin=: 2
dscRightOuterJoin=: 3

NB. DscLocationEnum

dscClient=: 0
dscServer=: 1
dscSystem=: _1

NB. DscObjectTypeEnum

dscobjDatamodel=: 512
dscobjGroupingDef=: 256
dscobjLookupRelationship=: 128
dscobjPageField=: 32
dscobjPageRelatedField=: 1024
dscobjPageRowsource=: 16
dscobjParameterValue=: 2048
dscobjRecordsetDef=: 8
dscobjSchemaField=: 2
dscobjSchemaParameter=: 8192
dscobjSchemaProperty=: 16384
dscobjSchemaRelatedField=: 4096
dscobjSchemaRelationship=: 4
dscobjSchemaRowsource=: 1
dscobjSublistRelationship=: 64
dscobjUnknown=: _1

NB. DscOfflineTypeEnum

dscOfflineMerge=: 1
dscOfflineNone=: 0
dscOfflineWorkflow=: 3
dscOfflineXMLDataFile=: 2

NB. DscPageRelTypeEnum

dscLookup=: 2
dscSublist=: 1

NB. DscRecordsetTypeEnum

dscSnapshot=: 1
dscUpdatableSnapshot=: 2

NB. DscRowsourceTypeEnum

dscCommandDSP=: 6
dscCommandFile=: 5
dscCommandText=: 3
dscFunction=: 5
dscInlineFunction=: 6
dscProcedure=: 4
dscTable=: 1
dscTableFunction=: 7
dscView=: 2

NB. DscSaveAsEnum

dscSaveAsEmbeddedXML=: 0
dscSaveAsXMLDataFile=: 1

NB. DscStatusEnum

dscDeleteCancel=: 1
dscDeleteOK=: 0
dscDeleteUserCancel=: 2

NB. DscTotalTypeEnum

dscAny=: 6
dscAvg=: 2
dscCount=: 5
dscMax=: 4
dscMin=: 3
dscNone=: 0
dscStdev=: 7
dscSum=: 1

NB. DscXMLLocationEnum

dscXMLDataFile=: 1
dscXMLEmbedded=: 0

NB. ExpandBitmapTypeEnum

ecBitmapOpenCloseFolder=: 2
ecBitmapPlusMinus=: 0
ecBitmapUpDownArrow=: 1

NB. LineStyleEnum

owcLineStyleAutomatic=: 1
owcLineStyleDash=: 3
owcLineStyleDashDot=: 5
owcLineStyleDashDotDot=: 6
owcLineStyleDot=: 4
owcLineStyleNone=: 0
owcLineStyleSolid=: 2

NB. LineWeightEnum

owcLineWeightHairline=: 0
owcLineWeightMedium=: 2
owcLineWeightThick=: 3
owcLineWeightThin=: 1

NB. MsoAppLanguageID

msoLanguageIDExeMode=: 4
msoLanguageIDHelp=: 3
msoLanguageIDInstall=: 1
msoLanguageIDUI=: 2
msoLanguageIDUIPrevious=: 5

NB. MsoLanguageID

msoLanguageIDAfrikaans=: 1078
msoLanguageIDAlbanian=: 1052
msoLanguageIDAmharic=: 1118
msoLanguageIDArabic=: 1025
msoLanguageIDArabicAlgeria=: 5121
msoLanguageIDArabicBahrain=: 15361
msoLanguageIDArabicEgypt=: 3073
msoLanguageIDArabicIraq=: 2049
msoLanguageIDArabicJordan=: 11265
msoLanguageIDArabicKuwait=: 13313
msoLanguageIDArabicLebanon=: 12289
msoLanguageIDArabicLibya=: 4097
msoLanguageIDArabicMorocco=: 6145
msoLanguageIDArabicOman=: 8193
msoLanguageIDArabicQatar=: 16385
msoLanguageIDArabicSyria=: 10241
msoLanguageIDArabicTunisia=: 7169
msoLanguageIDArabicUAE=: 14337
msoLanguageIDArabicYemen=: 9217
msoLanguageIDArmenian=: 1067
msoLanguageIDAssamese=: 1101
msoLanguageIDAzeriCyrillic=: 2092
msoLanguageIDAzeriLatin=: 1068
msoLanguageIDBasque=: 1069
msoLanguageIDBelgianDutch=: 2067
msoLanguageIDBelgianFrench=: 2060
msoLanguageIDBengali=: 1093
msoLanguageIDBosnian=: 4122
msoLanguageIDBrazilianPortuguese=: 1046
msoLanguageIDBulgarian=: 1026
msoLanguageIDBurmese=: 1109
msoLanguageIDByelorussian=: 1059
msoLanguageIDCatalan=: 1027
msoLanguageIDCherokee=: 1116
msoLanguageIDChineseHongKong=: 3076
msoLanguageIDChineseHongKongSAR=: 3076
msoLanguageIDChineseMacao=: 5124
msoLanguageIDChineseMacaoSAR=: 5124
msoLanguageIDChineseSingapore=: 4100
msoLanguageIDCroatian=: 1050
msoLanguageIDCzech=: 1029
msoLanguageIDDanish=: 1030
msoLanguageIDDivehi=: 1125
msoLanguageIDDutch=: 1043
msoLanguageIDDzongkhaBhutan=: 2129
msoLanguageIDEdo=: 1126
msoLanguageIDEnglishAUS=: 3081
msoLanguageIDEnglishBelize=: 10249
msoLanguageIDEnglishCanadian=: 4105
msoLanguageIDEnglishCaribbean=: 9225
msoLanguageIDEnglishIndonesia=: 14345
msoLanguageIDEnglishIreland=: 6153
msoLanguageIDEnglishJamaica=: 8201
msoLanguageIDEnglishNewZealand=: 5129
msoLanguageIDEnglishPhilippines=: 13321
msoLanguageIDEnglishSouthAfrica=: 7177
msoLanguageIDEnglishTrinidad=: 11273
msoLanguageIDEnglishTrinidadTobago=: 11273
msoLanguageIDEnglishUK=: 2057
msoLanguageIDEnglishUS=: 1033
msoLanguageIDEnglishZimbabwe=: 12297
msoLanguageIDEstonian=: 1061
msoLanguageIDFaeroese=: 1080
msoLanguageIDFarsi=: 1065
msoLanguageIDFilipino=: 1124
msoLanguageIDFinnish=: 1035
msoLanguageIDFrench=: 1036
msoLanguageIDFrenchCameroon=: 11276
msoLanguageIDFrenchCanadian=: 3084
msoLanguageIDFrenchCotedIvoire=: 12300
msoLanguageIDFrenchHaiti=: 15372
msoLanguageIDFrenchLuxembourg=: 5132
msoLanguageIDFrenchMali=: 13324
msoLanguageIDFrenchMonaco=: 6156
msoLanguageIDFrenchMorocco=: 14348
msoLanguageIDFrenchReunion=: 8204
msoLanguageIDFrenchSenegal=: 10252
msoLanguageIDFrenchWestIndies=: 7180
msoLanguageIDFrenchZaire=: 9228
msoLanguageIDFrisianNetherlands=: 1122
msoLanguageIDFulfulde=: 1127
msoLanguageIDGaelicIreland=: 2108
msoLanguageIDGaelicScotland=: 1084
msoLanguageIDGalician=: 1110
msoLanguageIDGeorgian=: 1079
msoLanguageIDGerman=: 1031
msoLanguageIDGermanAustria=: 3079
msoLanguageIDGermanLiechtenstein=: 5127
msoLanguageIDGermanLuxembourg=: 4103
msoLanguageIDGreek=: 1032
msoLanguageIDGuarani=: 1140
msoLanguageIDGujarati=: 1095
msoLanguageIDHausa=: 1128
msoLanguageIDHawaiian=: 1141
msoLanguageIDHebrew=: 1037
msoLanguageIDHindi=: 1081
msoLanguageIDHungarian=: 1038
msoLanguageIDIbibio=: 1129
msoLanguageIDIcelandic=: 1039
msoLanguageIDIgbo=: 1136
msoLanguageIDIndonesian=: 1057
msoLanguageIDInuktitut=: 1117
msoLanguageIDItalian=: 1040
msoLanguageIDJapanese=: 1041
msoLanguageIDKannada=: 1099
msoLanguageIDKanuri=: 1137
msoLanguageIDKashmiri=: 1120
msoLanguageIDKashmiriDevanagari=: 2144
msoLanguageIDKashmiriIndia=: 2144
msoLanguageIDKazakh=: 1087
msoLanguageIDKhmer=: 1107
msoLanguageIDKirghiz=: 1088
msoLanguageIDKonkani=: 1111
msoLanguageIDKorean=: 1042
msoLanguageIDKyrgyz=: 1088
msoLanguageIDLao=: 1108
msoLanguageIDLatin=: 1142
msoLanguageIDLatvian=: 1062
msoLanguageIDLithuanian=: 1063
msoLanguageIDMacedonian=: 1071
msoLanguageIDMalayalam=: 1100
msoLanguageIDMalayBruneiDarussalam=: 2110
msoLanguageIDMalaysian=: 1086
msoLanguageIDMaltese=: 1082
msoLanguageIDManipuri=: 1112
msoLanguageIDMaori=: 1153
msoLanguageIDMarathi=: 1102
msoLanguageIDMexicanSpanish=: 2058
msoLanguageIDMixed=: _2
msoLanguageIDMongolian=: 1104
msoLanguageIDNepali=: 1121
msoLanguageIDNone=: 0
msoLanguageIDNoProofing=: 1024
msoLanguageIDNorwegianBokmol=: 1044
msoLanguageIDNorwegianNynorsk=: 2068
msoLanguageIDOriya=: 1096
msoLanguageIDOromo=: 1138
msoLanguageIDPashto=: 1123
msoLanguageIDPolish=: 1045
msoLanguageIDPortuguese=: 2070
msoLanguageIDPunjabi=: 1094
msoLanguageIDRhaetoRomanic=: 1047
msoLanguageIDRomanian=: 1048
msoLanguageIDRomanianMoldova=: 2072
msoLanguageIDRussian=: 1049
msoLanguageIDRussianMoldova=: 2073
msoLanguageIDSamiLappish=: 1083
msoLanguageIDSanskrit=: 1103
msoLanguageIDSerbianCyrillic=: 3098
msoLanguageIDSerbianLatin=: 2074
msoLanguageIDSesotho=: 1072
msoLanguageIDSimplifiedChinese=: 2052
msoLanguageIDSindhi=: 1113
msoLanguageIDSindhiPakistan=: 2137
msoLanguageIDSinhalese=: 1115
msoLanguageIDSlovak=: 1051
msoLanguageIDSlovenian=: 1060
msoLanguageIDSomali=: 1143
msoLanguageIDSorbian=: 1070
msoLanguageIDSpanish=: 1034
msoLanguageIDSpanishArgentina=: 11274
msoLanguageIDSpanishBolivia=: 16394
msoLanguageIDSpanishChile=: 13322
msoLanguageIDSpanishColombia=: 9226
msoLanguageIDSpanishCostaRica=: 5130
msoLanguageIDSpanishDominicanRepublic=: 7178
msoLanguageIDSpanishEcuador=: 12298
msoLanguageIDSpanishElSalvador=: 17418
msoLanguageIDSpanishGuatemala=: 4106
msoLanguageIDSpanishHonduras=: 18442
msoLanguageIDSpanishModernSort=: 3082
msoLanguageIDSpanishNicaragua=: 19466
msoLanguageIDSpanishPanama=: 6154
msoLanguageIDSpanishParaguay=: 15370
msoLanguageIDSpanishPeru=: 10250
msoLanguageIDSpanishPuertoRico=: 20490
msoLanguageIDSpanishUruguay=: 14346
msoLanguageIDSpanishVenezuela=: 8202
msoLanguageIDSutu=: 1072
msoLanguageIDSwahili=: 1089
msoLanguageIDSwedish=: 1053
msoLanguageIDSwedishFinland=: 2077
msoLanguageIDSwissFrench=: 4108
msoLanguageIDSwissGerman=: 2055
msoLanguageIDSwissItalian=: 2064
msoLanguageIDSyriac=: 1114
msoLanguageIDTajik=: 1064
msoLanguageIDTamazight=: 1119
msoLanguageIDTamazightLatin=: 2143
msoLanguageIDTamil=: 1097
msoLanguageIDTatar=: 1092
msoLanguageIDTelugu=: 1098
msoLanguageIDThai=: 1054
msoLanguageIDTibetan=: 1105
msoLanguageIDTigrignaEritrea=: 2163
msoLanguageIDTigrignaEthiopic=: 1139
msoLanguageIDTraditionalChinese=: 1028
msoLanguageIDTsonga=: 1073
msoLanguageIDTswana=: 1074
msoLanguageIDTurkish=: 1055
msoLanguageIDTurkmen=: 1090
msoLanguageIDUkrainian=: 1058
msoLanguageIDUrdu=: 1056
msoLanguageIDUzbekCyrillic=: 2115
msoLanguageIDUzbekLatin=: 1091
msoLanguageIDVenda=: 1075
msoLanguageIDVietnamese=: 1066
msoLanguageIDWelsh=: 1106
msoLanguageIDXhosa=: 1076
msoLanguageIDYi=: 1144
msoLanguageIDYiddish=: 1085
msoLanguageIDYoruba=: 1130
msoLanguageIDZulu=: 1077

NB. NavButtonEnum

navbtnApplyFilter=: 10
navbtnDelete=: 5
navbtnHelp=: 12
navbtnMoveFirst=: 0
navbtnMoveLast=: 3
navbtnMoveNext=: 2
navbtnMovePrev=: 1
navbtnNew=: 4
navbtnSave=: 6
navbtnSortAscending=: 8
navbtnSortDescending=: 9
navbtnToggleFilter=: 11
navbtnUndo=: 7

NB. NotificationType

dscConnectionReset=: 0
dscDataReset=: 1

NB. OCCommandId

ocCommandAbout=: 1007
ocCommandAutoCalc=: 1016
ocCommandAutoFilter=: 1017
ocCommandChooser=: 1010
ocCommandCollapse=: 1013
ocCommandCopy=: 1002
ocCommandCut=: 1001
ocCommandExpand=: 1012
ocCommandExport=: 1004
ocCommandHelp=: 1006
ocCommandPaste=: 1003
ocCommandProperties=: 1005
ocCommandRefresh=: 1014
ocCommandSortAsc=: 2000
ocCommandSortDesc=: 2031
ocCommandUndo=: 1000

NB. PivotArrowModeEnum

plArrowModeAccept=: 0
plArrowModeEdit=: 1

NB. PivotCaretPositionEnum

plCaretPositionAtEnd=: 0
plCaretPositionAtMouse=: 1

NB. PivotCommandId

plCommandAbout=: 1007
plCommandAutoAverage=: 12089
plCommandAutoCalc=: 1016
plCommandAutoCount=: 12006
plCommandAutoFilter=: 1017
plCommandAutoMax=: 12008
plCommandAutoMin=: 12007
plCommandAutoStdDev=: 12090
plCommandAutoStdDevP=: 12092
plCommandAutoSum=: 12005
plCommandAutoVar=: 12091
plCommandAutoVarP=: 12093
plCommandBottomRightEdge=: 12017
plCommandCalculated=: 12110
plCommandChooser=: 1010
plCommandClearCustomOrdering=: 12154
plCommandCollapse=: 1013
plCommandConditionalFilter=: 1125
plCommandContextMenu=: 12066
plCommandCopy=: 1002
plCommandCreateCalculatedTotal=: 12102
plCommandCut=: 12157
plCommandDelete=: 1011
plCommandDeleteRow=: 12101
plCommandDemote=: 12039
plCommandDown=: 12029
plCommandDropzones=: 12009
plCommandEndEdit=: 12100
plCommandEnterDetails=: 12024
plCommandExitDetails=: 12025
plCommandExpand=: 1012
plCommandExpandIndicator=: 12051
plCommandExport=: 1004
plCommandExtendBottomRightEdge=: 12108
plCommandExtendDown=: 12075
plCommandExtendLeft=: 12072
plCommandExtendPageDown=: 12079
plCommandExtendPageLeft=: 12076
plCommandExtendPageRight=: 12077
plCommandExtendPageUp=: 12078
plCommandExtendRight=: 12073
plCommandExtendTopLeftEdge=: 12107
plCommandExtendUp=: 12074
plCommandFilter=: 12037
plCommandFilterByMenu=: 12065
plCommandFilterBySel=: 12001
plCommandFormatAlignAutomatic=: 12158
plCommandFormatAlignCenter=: 12142
plCommandFormatAlignLeft=: 12141
plCommandFormatAlignRight=: 12143
plCommandFormatBackColor=: 12148
plCommandFormatBold=: 12062
plCommandFormatComma=: 12061
plCommandFormatCurrency=: 12056
plCommandFormatDate=: 12059
plCommandFormatExponent=: 12058
plCommandFormatForeColor=: 12147
plCommandFormatGeneral=: 12055
plCommandFormatItalic=: 12063
plCommandFormatName=: 12144
plCommandFormatPercent=: 12057
plCommandFormatSize=: 12145
plCommandFormatTime=: 12060
plCommandFormatUnderline=: 12064
plCommandFormatUnderline2=: 12146
plCommandGroupByColumn=: 12035
plCommandGroupByRow=: 12034
plCommandGroupMembers=: 12155
plCommandHelp=: 1006
plCommandHideAllPropertiesInReport=: 12150
plCommandHideAllPropertiesInScreenTip=: 12152
plCommandHideDetails=: 12096
plCommandHyperlink=: 12082
plCommandInsertField=: 12004
plCommandLastDown=: 12023
plCommandLastLeft=: 12020
plCommandLastRight=: 12021
plCommandLastUp=: 12022
plCommandLeft=: 12026
plCommandLeftEdge=: 12014
plCommandMoveMemDown=: 12086
plCommandMoveMemLeft=: 12087
plCommandMoveMemRight=: 12088
plCommandMoveMemUp=: 12085
plCommandNextHorz=: 12012
plCommandNextHorzCell=: 12018
plCommandNextVert=: 12013
plCommandNextVertCell=: 12069
plCommandOpenHyperlinkInPlace=: 12083
plCommandOpenHyperlinkInWindow=: 12084
plCommandPageDown=: 12031
plCommandPageLeft=: 12032
plCommandPageRight=: 12033
plCommandPageUp=: 12030
plCommandPaste=: 1003
plCommandPrevHorz=: 12067
plCommandPrevHorzCell=: 12019
plCommandPrevVert=: 12068
plCommandPrevVertCell=: 12070
plCommandProfile=: 12153
plCommandPromote=: 12038
plCommandProperties=: 1005
plCommandRefresh=: 1014
plCommandRemove=: 12010
plCommandRight=: 12027
plCommandRightEdge=: 12015
plCommandSelectAll=: 12054
plCommandSelectField=: 12052
plCommandSelectRow=: 12053
plCommandShowAll=: 1121
plCommandShowAllPropertiesInReport=: 12149
plCommandShowAllPropertiesInScreenTip=: 12151
plCommandShowAs=: 12134
plCommandShowAsNormal=: 12135
plCommandShowAsPercentOfColumnParent=: 12139
plCommandShowAsPercentOfColumnTotal=: 12137
plCommandShowAsPercentOfGrandTotal=: 12140
plCommandShowAsPercentOfRowParent=: 12138
plCommandShowAsPercentOfRowTotal=: 12136
plCommandShowBottom1=: 1110
plCommandShowBottom10=: 1113
plCommandShowBottom10Percent=: 1118
plCommandShowBottom1Percent=: 1115
plCommandShowBottom2=: 1111
plCommandShowBottom25=: 1114
plCommandShowBottom25Percent=: 1119
plCommandShowBottom2Percent=: 1116
plCommandShowBottom5=: 1112
plCommandShowBottom5Percent=: 1117
plCommandShowBottomNMenu=: 1124
plCommandShowDetails=: 12095
plCommandShowOther=: 1120
plCommandShowTop1=: 1100
plCommandShowTop10=: 1103
plCommandShowTop10Percent=: 1108
plCommandShowTop1Percent=: 1105
plCommandShowTop2=: 1101
plCommandShowTop25=: 1104
plCommandShowTop25Percent=: 1109
plCommandShowTop2Percent=: 1106
plCommandShowTop5=: 1102
plCommandShowTop5Percent=: 1107
plCommandShowTopNMenu=: 1123
plCommandSortAsc=: 2000
plCommandSortDesc=: 2031
plCommandStartEdit=: 12099
plCommandSubtotal=: 12042
plCommandTogglePropertiesInReport=: 12097
plCommandTogglePropertiesInScreenTip=: 12098
plCommandTogglePropertyInReport=: 12900
plCommandTogglePropertyInScreenTip=: 12950
plCommandToolbar=: 12044
plCommandTopLeftEdge=: 12016
plCommandUngroup=: 12036
plCommandUngroupMembers=: 12156
plCommandUp=: 12028

NB. PivotDataReasonEnum

plDataReasonAdhocFieldAdded=: 43
plDataReasonAdhocFieldDeleted=: 44
plDataReasonAdhocMemberChanged=: 45
plDataReasonAllIncludeExcludeChange=: 42
plDataReasonAllowDetailsChange=: 4
plDataReasonAllowMultiFilterChange=: 41
plDataReasonAlwaysIncludeInCubeChange=: 46
plDataReasonCommandTextChange=: 31
plDataReasonConnectionStringChange=: 32
plDataReasonDataMemberChange=: 23
plDataReasonDataSourceChange=: 22
plDataReasonDisplayCalculatedMembersChange=: 10
plDataReasonDisplayCellColorChange=: 49
plDataReasonDisplayEmptyMembersChange=: 19
plDataReasonExcludedMembersChange=: 16
plDataReasonExpressionChange=: 47
plDataReasonFieldNameChange=: 53
plDataReasonFieldSetDeleted=: 39
plDataReasonFieldSetNameChange=: 52
plDataReasonFilterContextChange=: 9
plDataReasonFilterCrossJoinsChange=: 50
plDataReasonFilterFunctionChange=: 8
plDataReasonFilterFunctionValueChange=: 13
plDataReasonFilterOnChange=: 11
plDataReasonFilterOnScopeChange=: 12
plDataReasonGroupEndChange=: 30
plDataReasonGroupIntervalChange=: 27
plDataReasonGroupOnChange=: 24
plDataReasonGroupStartChange=: 26
plDataReasonIncludedMembersChange=: 15
plDataReasonInsertFieldSet=: 0
plDataReasonInsertTotal=: 2
plDataReasonIsFilteredChange=: 28
plDataReasonIsIncludedChange=: 17
plDataReasonMemberPropertyDisplayInChange=: 34
plDataReasonMemberPropertyIsIncludedChange=: 33
plDataReasonOrderedMembersChange=: 29
plDataReasonRecordChanged=: 40
plDataReasonRefreshDataSource=: 51
plDataReasonRemoveFieldSet=: 1
plDataReasonRemoveTotal=: 3
plDataReasonSortDirectionChange=: 5
plDataReasonSortOnChange=: 6
plDataReasonSortOnScopeChange=: 7
plDataReasonSubtotalsChange=: 35
plDataReasonTotalAllMembersChange=: 48
plDataReasonTotalDeleted=: 38
plDataReasonTotalExpressionChange=: 36
plDataReasonTotalFunctionChange=: 20
plDataReasonTotalNameChange=: 14
plDataReasonTotalSolveOrderChange=: 37
plDataReasonUnknown=: 25
plDataReasonUser=: 21

NB. PivotEditModeEnum

plEditInProgress=: 1
plEditNone=: 0

NB. PivotExportActionEnum

plExportActionNone=: 0
plExportActionOpenInExcel=: 1

NB. PivotFieldFilterFunctionEnum

plFilterFunctionBottomCount=: 4
plFilterFunctionBottomPercent=: 6
plFilterFunctionBottomSum=: 8
plFilterFunctionNone=: 0
plFilterFunctionTopCount=: 3
plFilterFunctionTopPercent=: 5
plFilterFunctionTopSum=: 7

NB. PivotFieldGroupOnEnum

plGroupOnDays=: 6
plGroupOnEachValue=: 0
plGroupOnHours=: 7
plGroupOnInterval=: 10
plGroupOnMinutes=: 8
plGroupOnMonths=: 4
plGroupOnPrefixChars=: 1
plGroupOnQtrs=: 3
plGroupOnSeconds=: 9
plGroupOnWeeks=: 5
plGroupOnYears=: 2

NB. PivotFieldSetAllIncludeExcludeEnum

plAllDefault=: 0
plAllExclude=: 2
plAllInclude=: 1

NB. PivotFieldSetOrientationEnum

plOrientationColumnAxis=: 1
plOrientationDataAxis=: 8
plOrientationFilterAxis=: 4
plOrientationNone=: 0
plOrientationPageAxis=: 16
plOrientationRowAxis=: 2

NB. PivotFieldSetTypeEnum

plFieldSetTypeOther=: 2
plFieldSetTypeTime=: 1
plFieldSetTypeUnknown=: 3
plFieldSetTypeUserDefined=: 4

NB. PivotFieldSortDirectionEnum

plSortDirectionAscending=: 1
plSortDirectionCustom=: 4
plSortDirectionCustomAscending=: 5
plSortDirectionCustomDescending=: 6
plSortDirectionDefault=: 0
plSortDirectionDescending=: 2

NB. PivotFieldTypeEnum

plTypeCalculated=: 2
plTypeCustomGroup=: 17
plTypeRegular=: 1
plTypeTimeDays=: 9
plTypeTimeHalfYears=: 5
plTypeTimeHours=: 10
plTypeTimeMinutes=: 11
plTypeTimeMonths=: 7
plTypeTimeQuarters=: 6
plTypeTimeSeconds=: 12
plTypeTimeUndefined=: 13
plTypeTimeWeekdays=: 16
plTypeTimeWeeks=: 8
plTypeTimeYears=: 4
plTypeUnknown=: 14
plTypeUserDefined=: 15

NB. PivotFilterUpdateMemberStateEnum

plMemberStateChecked=: 2
plMemberStateClear=: 1
plMemberStateGray=: 3

NB. PivotHAlignmentEnum

plHAlignAutomatic=: 0
plHAlignCenter=: 2
plHAlignLeft=: 1
plHAlignRight=: 3

NB. PivotMemberCustomGroupTypeEnum

plGroupTypeCustomGroup=: 2
plGroupTypeDynamicOther=: 6
plGroupTypeFallThrough=: 3
plGroupTypePlaceHolder=: 4
plGroupTypeRegular=: 1
plGroupTypeStaticOther=: 5

NB. PivotMemberFindFormatEnum

plFindFormatMember=: 0
plFindFormatPathHex=: 3
plFindFormatPathInt=: 2
plFindFormatPathName=: 1

NB. PivotMemberPropertyDisplayEnum

plDisplayPropertyInAll=: 3
plDisplayPropertyInReport=: 1
plDisplayPropertyInScreenTip=: 2
plDisplayPropertyNone=: 0

NB. PivotMembersCompareByEnum

plMembersCompareByName=: 1
plMembersCompareByUniqueName=: 0

NB. PivotScrollTypeEnum

plScrollTypeAll=: 15
plScrollTypeBottom=: 4
plScrollTypeLeft=: 2
plScrollTypeNone=: 0
plScrollTypeRight=: 8
plScrollTypeTop=: 1

NB. PivotShowAsEnum

plShowAsNormal=: 0
plShowAsPercentOfColumnParent=: 4
plShowAsPercentOfColumnTotal=: 2
plShowAsPercentOfGrandTotal=: 5
plShowAsPercentOfRowParent=: 3
plShowAsPercentOfRowTotal=: 1

NB. PivotTableExpandEnum

plExpandAlways=: 1
plExpandAutomatic=: 0
plExpandNever=: 2

NB. PivotTableReasonEnum

plPivotTableReasonFieldAdded=: 3
plPivotTableReasonFieldSetAdded=: 2
plPivotTableReasonTotalAdded=: 0
plPivotTableReasonTotalDeleted=: 1

NB. PivotTotalFunctionEnum

plFunctionAverage=: 5
plFunctionCalculated=: 127
plFunctionCount=: 2
plFunctionMax=: 4
plFunctionMin=: 3
plFunctionStdDev=: 6
plFunctionStdDevP=: 10
plFunctionSum=: 1
plFunctionUnknown=: 0
plFunctionVar=: 7
plFunctionVarP=: 11

NB. PivotTotalTypeEnum

plTotalTypeCalculated=: 3
plTotalTypeIntrinsic=: 1
plTotalTypeUserDefined=: 2

NB. PivotViewReasonEnum

plViewReasonAlignmentChange=: 18
plViewReasonAllowAdditionsChange=: 64
plViewReasonAllowCustomOrderingChange=: 60
plViewReasonAllowDeletionsChange=: 65
plViewReasonAllowEditsChange=: 63
plViewReasonAllowFilteringChange=: 32
plViewReasonAllowGroupingChange=: 33
plViewReasonAllowPropertyToolbox=: 61
plViewReasonAutoFitChange=: 40
plViewReasonBackColorChange=: 17
plViewReasonCellExpandedChange=: 9
plViewReasonDataChange=: 2
plViewReasonDataMemberCaptionChange=: 72
plViewReasonDetailLeftChange=: 21
plViewReasonDetailLeftOffsetChange=: 48
plViewReasonDetailMaxHeightChange=: 44
plViewReasonDetailMaxWidthChange=: 43
plViewReasonDetailRowHeightChange=: 10
plViewReasonDetailTopChange=: 20
plViewReasonDetailTopOffsetChange=: 47
plViewReasonDisplayInFieldListChange=: 73
plViewReasonDisplayOutlineChange=: 26
plViewReasonDisplayScreenTipsChange=: 68
plViewReasonDisplayToolbarChange=: 37
plViewReasonExpandDetailsChange=: 42
plViewReasonExpandMembersChange=: 62
plViewReasonFieldCaptionChange=: 27
plViewReasonFieldDetailWidthChange=: 11
plViewReasonFieldExpandedChange=: 41
plViewReasonFieldGroupedHeightChange=: 53
plViewReasonFieldGroupedWidthChange=: 12
plViewReasonFieldSetCaptionChange=: 28
plViewReasonFieldSetWidthChange=: 14
plViewReasonFontBoldChange=: 5
plViewReasonFontItalicChange=: 6
plViewReasonFontNameChange=: 3
plViewReasonFontSizeChange=: 4
plViewReasonFontUnderlineChange=: 7
plViewReasonForeColorChange=: 16
plViewReasonHeightChange=: 35
plViewReasonHideDetails=: 59
plViewReasonIsHyperlinkChange=: 49
plViewReasonKillFocus=: 67
plViewReasonLabelCaptionChange=: 29
plViewReasonLabelVisibleChange=: 36
plViewReasonLeftChange=: 23
plViewReasonLeftOffsetChange=: 46
plViewReasonMaxHeightChange=: 38
plViewReasonMaxWidthChange=: 39
plViewReasonMemberCaptionChange=: 30
plViewReasonMemberCaptionsChange=: 70
plViewReasonMemberExpandedChange=: 8
plViewReasonMemberHeightChange=: 54
plViewReasonMemberPropertiesOrderChange=: 52
plViewReasonMemberPropertyCaptionChange=: 51
plViewReasonMemberPropertyDisplayInChange=: 50
plViewReasonMemberWidthChange=: 55
plViewReasonNumberFormatChange=: 19
plViewReasonPropertyCaptionWidthChange=: 71
plViewReasonPropertyHeightChange=: 57
plViewReasonPropertyValueWidthChange=: 56
plViewReasonRightToLeftChange=: 24
plViewReasonSelectionChange=: 0
plViewReasonSetFocus=: 66
plViewReasonShowAsChange=: 69
plViewReasonShowDetails=: 58
plViewReasonSystemColorChange=: 1
plViewReasonToolbarChange=: 74
plViewReasonTopChange=: 22
plViewReasonTopOffsetChange=: 45
plViewReasonTotalCaptionChange=: 31
plViewReasonTotalOrientationChange=: 25
plViewReasonTotalWidthChange=: 15
plViewReasonUseProviderFormattingChange=: 75
plViewReasonViewDetailWidthChange=: 13
plViewReasonWidthChange=: 34
plViewReasonXMLApplied=: 76

NB. PivotViewTotalOrientationEnum

plTotalOrientationColumn=: 2
plTotalOrientationRow=: 1

NB. ProviderType

providerTypeMultidimensional=: 3
providerTypeRelational=: 2
providerTypeUnknown=: 1

NB. SectTypeEnum

sectTypeCaption=: 1
sectTypeFooter=: 3
sectTypeHeader=: 2
sectTypeNone=: 0
sectTypeRecNav=: 4

NB. SheetCommandEnum

ssAutoFilter=: 15
ssCalculate=: 0
ssClear=: 14
ssCopy=: 7
ssCut=: 6
ssDeleteColumns=: 5
ssDeleteRows=: 4
ssExport=: 9
ssFind=: 13
ssHelp=: 17
ssInsertColumns=: 3
ssInsertRows=: 2
ssPaste=: 8
ssProperties=: 16
ssSortAscending=: 11
ssSortDescending=: 12
ssUndo=: 10

NB. SheetExportActionEnum

ssExportActionNone=: 0
ssExportActionOpenInExcel=: 1

NB. SheetExportFormat

ssExportAsAppropriate=: 0
ssExportHTML=: 2
ssExportXMLSpreadsheet=: 1

NB. SheetFilterFunction

ssFilterFunctionExclude=: 2
ssFilterFunctionInclude=: 1

NB. SpreadSheetCommandId

ssCommandAbout=: 1007
ssCommandAutoFilter=: 10001
ssCommandAutosum=: 10000
ssCommandBold=: 1052
ssCommandClear=: 10002
ssCommandCopy=: 1002
ssCommandCut=: 1001
ssCommandDeleteCols=: 10007
ssCommandDeleteQuery=: 10071
ssCommandDeleteRows=: 10006
ssCommandEat=: 10054
ssCommandEditQuery=: 10070
ssCommandEnterEditMode=: 10038
ssCommandEscape=: 10041
ssCommandExpandDown=: 10033
ssCommandExpandLeft=: 10030
ssCommandExpandMenu=: 10053
ssCommandExpandPageDown=: 10046
ssCommandExpandPageLeft=: 10065
ssCommandExpandPageRight=: 10063
ssCommandExpandPageUp=: 10048
ssCommandExpandRight=: 10032
ssCommandExpandToEndDown=: 10037
ssCommandExpandToEndLeft=: 10034
ssCommandExpandToEndRight=: 10036
ssCommandExpandToEndUp=: 10035
ssCommandExpandToHome=: 10052
ssCommandExpandToLast=: 10043
ssCommandExpandToOrigin=: 10050
ssCommandExpandUp=: 10031
ssCommandExport=: 1004
ssCommandHelp=: 1006
ssCommandInsertCols=: 10009
ssCommandInsertRows=: 10008
ssCommandItalic=: 1053
ssCommandMakeActiveCellVisible=: 10066
ssCommandMoveDown=: 10017
ssCommandMoveLeft=: 10014
ssCommandMoveNext=: 10022
ssCommandMovePageDown=: 10045
ssCommandMovePageLeft=: 10064
ssCommandMovePageRight=: 10062
ssCommandMovePageUp=: 10047
ssCommandMovePrevious=: 10023
ssCommandMoveRight=: 10016
ssCommandMoveToEndDown=: 10029
ssCommandMoveToEndLeft=: 10026
ssCommandMoveToEndRight=: 10028
ssCommandMoveToEndUp=: 10027
ssCommandMoveToHome=: 10051
ssCommandMoveToLast=: 10042
ssCommandMoveToLastInRow=: 10044
ssCommandMoveToOrigin=: 10049
ssCommandMoveUp=: 10015
ssCommandNewSheet=: 10057
ssCommandNextSheet=: 10055
ssCommandOpenHyperlink=: 10073
ssCommandPaste=: 1003
ssCommandPrevSheet=: 10056
ssCommandProperties=: 1005
ssCommandRecalc=: 10059
ssCommandRecalcForce=: 10010
ssCommandRefresh=: 10060
ssCommandRefreshAll=: 10061
ssCommandRefreshData=: 10068
ssCommandSaveData=: 10069
ssCommandScrollDown=: 10021
ssCommandScrollLeft=: 10018
ssCommandScrollRight=: 10020
ssCommandScrollUp=: 10019
ssCommandSelectAll=: 10013
ssCommandSelectArray=: 10058
ssCommandSelectArraySilent=: 10067
ssCommandSelectCol=: 10012
ssCommandSelectRow=: 10011
ssCommandSetChartRange=: 10072
ssCommandShowContextMenu=: 10039
ssCommandSortAsc=: 2000
ssCommandSortAscLast=: 2030
ssCommandSortDesc=: 2031
ssCommandSortDescLast=: 2061
ssCommandTabNext=: 10024
ssCommandTabPrevious=: 10025
ssCommandToggleToolbar=: 10040
ssCommandUnderline=: 1054
ssCommandUndo=: 1000

NB. SynchronizationStatus

dscSynchronizationDone=: 1
dscSynchronizing=: 0

NB. TipTypeEnum

eTipTypeAuto=: 2
eTipTypeHTML=: 1
eTipTypeNone=: _1
eTipTypeText=: 0

NB. UnderlineStyleEnum

owcUnderlineStyleDouble=: 2
owcUnderlineStyleDoubleAccounting=: 4
owcUnderlineStyleNone=: 0
owcUnderlineStyleSingle=: 1
owcUnderlineStyleSingleAccounting=: 3

NB. XlApplicationInternational

xl24HourClock=: 33
xl4DigitYears=: 43
xlAlternateArraySeparator=: 16
xlColumnSeparator=: 14
xlCountryCode=: 1
xlCountrySetting=: 2
xlCurrencyBefore=: 37
xlCurrencyCode=: 25
xlCurrencyDigits=: 27
xlCurrencyLeadingZeros=: 40
xlCurrencyMinusSign=: 38
xlCurrencyNegative=: 28
xlCurrencySpaceBefore=: 36
xlCurrencyTrailingZeros=: 39
xlDateOrder=: 32
xlDateSeparator=: 17
xlDayCode=: 21
xlDayLeadingZero=: 42
xlDecimalSeparator=: 3
xlGeneralFormatName=: 26
xlHourCode=: 22
xlLeftBrace=: 12
xlLeftBracket=: 10
xlListSeparator=: 5
xlLowerCaseColumnLetter=: 9
xlLowerCaseRowLetter=: 8
xlMDY=: 44
xlMetric=: 35
xlMinuteCode=: 23
xlMonthCode=: 20
xlMonthLeadingZero=: 41
xlMonthNameChars=: 30
xlNoncurrencyDigits=: 29
xlNonEnglishFunctions=: 34
xlRightBrace=: 13
xlRightBracket=: 11
xlRowSeparator=: 15
xlSecondCode=: 24
xlThousandsSeparator=: 4
xlTimeLeadingZero=: 45
xlTimeSeparator=: 18
xlUpperCaseColumnLetter=: 7
xlUpperCaseRowLetter=: 6
xlWeekdayNameChars=: 31
xlYearCode=: 19

NB. XlBordersIndex

xlDiagonalDown=: 5
xlDiagonalUp=: 6
xlEdgeBottom=: 9
xlEdgeLeft=: 7
xlEdgeRight=: 10
xlEdgeTop=: 8
xlInsideHorizontal=: 12
xlInsideVertical=: 11

NB. XlBorderWeight

xlHairline=: 1
xlMedium=: _4138
xlThick=: 4
xlThin=: 2

NB. XlCalculation

xlCalculationAutomatic=: _4105
xlCalculationManual=: _4135
xlCalculationSemiautomatic=: 2

NB. XlColorIndex

xlColorIndexAutomatic=: _4105
xlColorIndexNone=: _4142

NB. XlConstants

xlAutomatic=: _4105
xlNone=: _4142

NB. XlDeleteShiftDirection

xlShiftToLeft=: _4159
xlShiftUp=: _4162

NB. XlDirection

xlDown=: _4121
xlToLeft=: _4159
xlToRight=: _4161
xlUp=: _4162

NB. XlFindLookIn

xlComments=: _4144
xlFormulas=: _4123
xlValues=: _4163

NB. XlHAlign

xlHAlignCenter=: _4108
xlHAlignCenterAcrossSelection=: 7
xlHAlignDistributed=: _4117
xlHAlignFill=: 5
xlHAlignGeneral=: 1
xlHAlignJustify=: _4130
xlHAlignLeft=: _4131
xlHAlignRight=: _4152

NB. XlInsertShiftDirection

xlShiftDown=: _4121
xlShiftToRight=: _4161

NB. XlLineStyle

xlContinuous=: 1
xlDash=: _4115
xlDashDot=: 4
xlDashDotDot=: 5
xlDot=: _4118
xlDouble=: _4119
xlLineStyleNone=: _4142
xlSlantDashDot=: 13

NB. XlLookAt

xlPart=: 2
xlWhole=: 1

NB. XlOrientation

xlDownward=: _4170
xlHorizontal=: _4128
xlUpward=: _4171
xlVertical=: _4166

NB. XlRangeValueType

xlRangeValueCSV=: 1001
xlRangeValueDefault=: 10
xlRangeValueHTML=: 1000
xlRangeValueXMLSpreadsheet=: 11

NB. XlReadingOrder

xlContext=: _5002
xlLTR=: _5003
xlRTL=: _5004

NB. XlReferenceStyle

xlA1=: 1
xlR1C1=: _4150

NB. XlSearchDirection

xlNext=: 1
xlPrevious=: 2

NB. XlSearchOrder

xlByColumns=: 2
xlByRows=: 1

NB. XlSheetType

xlChart=: _4109
xlDialogSheet=: _4116
xlExcel4IntlMacroSheet=: 4
xlExcel4MacroSheet=: 3
xlWorksheet=: _4167

NB. XlSheetVisibility

xlSheetHidden=: 0
xlSheetVeryHidden=: 2
xlSheetVisible=: _1

NB. XlSortOrder

xlAscending=: 1
xlDescending=: 2

NB. XlUnderlineStyle

xlUnderlineStyleDouble=: _4119
xlUnderlineStyleDoubleAccounting=: 5
xlUnderlineStyleNone=: _4142
xlUnderlineStyleSingle=: 2
xlUnderlineStyleSingleAccounting=: 4

NB. XlVAlign

xlVAlignBottom=: _4107
xlVAlignCenter=: _4108
xlVAlignDistributed=: _4117
xlVAlignJustify=: _4130
xlVAlignTop=: _4160

NB. XlWindowType

xlChartAsWindow=: 5
xlChartInPlace=: 4
xlClipboard=: 3
xlInfo=: _4129
xlWorkbook=: 1

NB. XlYesNoGuess

xlGuess=: 0
xlNo=: 2
xlYes=: 1
