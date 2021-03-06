function isLocalStorageNameSupported() 
{
    var testKey = 'test', storage = window.localStorage;
    try 
    {
        storage.setItem(testKey, '1');
        storage.removeItem(testKey);
        return true;
    } 
    catch (error) 
    {
        return false;
    }
}

var dashboardApp = angular.module('DashBoard', ["ui.sortable"]);

dashboardApp.factory('summaryData', ['$http', function($http){
  return {
    index: function(search, callback){
      if (!search){
        search = ""
      }else{
        search = "?search="+search;
      }
      $http.get("/datacards" + search).then(callback);
    },
    show: function(d1, d2, search, callback){
      $http.get("datacard?start=" + d1 + "&end="+ d2 + "&search=" + search).then(callback);
    },
    detail: function(d1, d2, attr, callback){
      $http.get("datadetail?start=" + d1 + "&end="+ d2 + "&attribute=" + attr).then(callback);
    },
    getAll: function(callback){
      $http.get("mobile-summary").then(callback);
      if(isLocalStorageNameSupported()){
        window.localStorage.setItem('downloadTime', +(new Date));
      }
    }
  };
}]);

dashboardApp.controller("CardListCtrl", ["$scope", "summaryData", function($scope, summaryData){
  $scope.search = "";
  $scope.loading = true;
  $scope.filterHide = true;
  $scope.searchFilterHide = true;
  $scope.start_date = new Date((new Date).getTime() - (7 * 24 * 60 * 60 * 1000));
  $scope.end_date = new Date;
  $scope.choice_by = "";
  $scope.modalShow = false;
  $scope.currentActive = 'cards';
  $scope.cacheLength = 24; // hours
  $scope.attrMap = {
    sunday: "Sunday Attendance",
    ft: "First Timers",
    newConv: "New Converts",
    nbs: "Started NBS",
    fnbs: "Finished NBS",
    bap: "Baptised",
    tithe: "First &amp; Best"
  }
  $scope.filterToggle = function(){
    $scope.filterHide = !$scope.filterHide;
  }
  $scope.searchFilterToggle = function(){
    $scope.searchFilterHide = !$scope.searchFilterHide;
  }
  $scope.Math = window.Math;
  $scope.addOne = function(card){
    card.sunday_att += 1;
  };
  $scope.reloadData = function(){
    $scope.loading = true;
    if (isLocalStorageNameSupported()){
    var last_download = window.localStorage.getItem("downloadTime"),
        cachedCards = window.localStorage.getItem("seedCards");
    }

    if (isLocalStorageNameSupported() && !$scope.search && cachedCards && (+(new Date) - last_download < (1000 * 60 * 60 * $scope.cacheLength))){
      $scope.cards = JSON.parse(cachedCards);
      $scope.loading = false;
      $scope.search = ""
      $scope.filterHide = true;
      $scope.searchFilterHide = true;
    }else{
      summaryData.index($scope.search, function(cards){
        $scope.cards = cards.data;
        if (!$scope.search && isLocalStorageNameSupported()){
          window.localStorage.setItem("seedCards", JSON.stringify(cards.data));
        }      
        $scope.loading = false;
        $scope.search = ""
        $scope.filterHide = true;
        $scope.searchFilterHide = true;
      })
    }
  }

  $scope.searchData = function(){
    // $scope.loading = true;
    summaryData.show($scope.start_date.toISOString().split("T")[0], $scope.end_date.toISOString().split("T")[0], $scope.searchTerm, function(card){
      $scope.card = card.data;
      // $scope.searchFilterHide = false;
      $scope.hasSearched = true;
    })
  }
  $scope.getAllCard = function(){
    summaryData.show($scope.start_date.toISOString().split("T")[0], $scope.end_date.toISOString().split("T")[0], "", function(card){
      $scope.card = card.data;
      $scope.hasSearched = true;
    })
  };
  $scope.updateDate = function(){
    if($scope.hasSearched) $scope.searchData();
  }
  $scope.reloadData();
  $scope.detailLoading = true;
  $scope.getMasterJSON = function(){
    if (isLocalStorageNameSupported()){
      var last_download = window.localStorage.getItem("downloadTime");
    }
    if(isLocalStorageNameSupported() && last_download && (+(new Date) - last_download < (1000 * 60 * 60 * $scope.cacheLength))){
      $scope.allData = JSON.parse(window.localStorage.getItem('masterJSON'));
      $scope.$apply($scope.setInfoBox)
      $scope.setBaseChartData();
      $scope.detailLoading = false;
      $scope.chart = $scope.drawChart();
      $scope.showTrendChart();
    }else{
      summaryData.getAll(function(data){
        if (isLocalStorageNameSupported()){
          window.localStorage.setItem('masterJSON', JSON.stringify(data.data));
        }
        $scope.allData = data.data;
        $scope.setInfoBox()
        $scope.setBaseChartData();
        $scope.detailLoading = false;
        $scope.chart = $scope.drawChart();
        $scope.showTrendChart();
      });
    }
  }
  $scope.setInfoBox = function(){
    $scope.infoStarted = $scope.allData.information["Date Started"];
    $scope.infoBranches = $scope.allData.information["Branches"];
    $scope.infoChurchGroups = $scope.allData.information["Church Groups"];
    $scope.infoChurchPlanters = $scope.allData.information["Church Planters"];
    $scope.infoElders = $scope.allData.information["Elders"];
    $scope.infoLondonCampuses = $scope.allData.information["London Campuses"];
    $scope.infoAVG = $scope.allData.information["Past Year Average Weekly Attendance"];
    $scope.infoPastors = $scope.allData.information["Pastors"];
    $scope.infoChurches = $scope.allData.information["Total Campus Churches"];
    $scope.infoLoaded = !$scope.infoLoaded;
  }
  $scope.toggleCard = function(card){
    card.show = !card.show;
  }
  $scope.showModal = function(name, mob_name, attr, attr_name){
    $scope.modalHeader = attr_name || $scope.modalHeader;
    $scope.subHeader = name || $scope.subHeader;
    $scope.cardName = mob_name || $scope.cardName
    $scope.chartAttr = attr || $scope.chartAttr;
    $scope.currentActive = 'charts';
    $scope.reDrawChart();
    document.getElementById('chartContainer').focus();
  }
  $scope.trendChartAttr = 'sunday'
  $scope.showTrendChart = function(){
    $scope.trendChartHeader = $scope.attrMap[$scope.trendChartAttr] ? "Monthly " + $scope.attrMap[$scope.trendChartAttr] : "Sunday Attendance"
    $scope.trendChartSubheader = $scope.trendTarget || "All UK"
    $scope.reDrawTrendChart();
    $scope.trendCount = 1;
  };
  $scope.resetTrendChart = function(){
    $scope.trendChartAttr = 'sunday';
    $scope.trendGrouping = '';
    $scope.trendTarget = '';
    $scope.showTrendChart();
  }
  $scope.reDrawTrendChart = function(){
    if($scope.allData){
      $scope.trendData = []
      for (var i = 0; i < $scope.lastTwelve.length; i++){
        if($scope.trendGrouping && $scope.trendTarget){
          $scope.trendData.push([$scope.lastTwelve[i], +$scope.allData[$scope.trendGrouping][$scope.trendTarget][$scope.lastTwelve[i][0]][$scope.trendChartAttr]])
        }else{
          $scope.trendData.push([$scope.lastTwelve[i], +$scope.allData["totals"][$scope.lastTwelve[i][0]][$scope.trendChartAttr]])
        }
      }
      setTimeout(function(){
        $scope.trendChart = $scope.drawTrendChart();
      }, 100)
    }
  };
  $scope.addTrendAttribute = function(){
    if( $scope.addedAttr && $scope.addedAttr !== $scope.trendChartAttr && $scope.trendCount < 3){
      var trendData = []
      $scope.trendCount++
      for (var i = 0; i < $scope.lastTwelve.length; i++){
        if($scope.trendGrouping && $scope.trendTarget){
          trendData.push([$scope.lastTwelve[i], +$scope.allData[$scope.trendGrouping][$scope.trendTarget][$scope.lastTwelve[i][0]][$scope.addedAttr]])
        }else{
          trendData.push([$scope.lastTwelve[i], +$scope.allData["totals"][$scope.lastTwelve[i][0]][$scope.addedAttr]])
        }
      }
      $scope.trendChart.addSeries({
        type: "spline",
        name: "Monthly " + $scope.attrMap[$scope.addedAttr],
        data: trendData.filter(function(ele){return ele[1] > 0 })
      })
      // $scope.trendChart.legend.options.enabled = true;
      $scope.addedAttr = "";
      // console.log($scope.trendChart);
    }
  };
  $scope.reDrawChart = function(){
    $scope.modalHeader = $scope.attrMap[$scope.chartAttr];
    $scope.subHeader = $scope.cardName;
    if ($scope.chartData){
      $scope.chartData = [];
      $scope.drilldownData = [];
      var j = 0;
      if($scope.compareGrouping == "region"){
        for (var region in $scope.allData.totals_by_region){
          var reg = $scope.allData.totals_by_region[region]
          $scope.chartData.push({name: region, y: +$scope.allData.totals_by_region[region][$scope.cardName][$scope.chartAttr], drilldown: region})
          $scope.drilldownData.push({id: region, data: []})
          for (var i=0; i < reg.groups.length; i++){
            var church_group = reg.groups[i]
            $scope.drilldownData[j].data.push({
              name: reg.groups[i],
              y: +$scope.allData.totals_by_group[church_group][$scope.cardName][$scope.chartAttr], drilldown: church_group
            })
          }
          j += 1;
        }
      }else if($scope.compareGrouping == "city"){
        for (var region in $scope.allData.totals_by_city){
          $scope.chartData.push({name: region, y: +$scope.allData.totals_by_city[region][$scope.cardName][$scope.chartAttr], drilldown: region})
        }
      }else if($scope.compareGrouping == "church_group"){
        for (var region in $scope.allData.totals_by_group){
          $scope.chartData.push({name: region, y: +$scope.allData.totals_by_group[region][$scope.cardName][$scope.chartAttr], drilldown: region})
        }
      }else if($scope.compareGrouping == "church"){
        for (var region in $scope.allData.totals_by_church){
          $scope.chartData.push({name: region, y: +$scope.allData.totals_by_church[region][$scope.cardName][$scope.chartAttr]})
        }
      }else if($scope.compareGrouping == "campus"){
        for (var region in $scope.allData.totals_by_campus){
          $scope.chartData.push({name: region, y: +$scope.allData.totals_by_campus[region][$scope.cardName][$scope.chartAttr]})
        }
      }

      setTimeout(function(){
        $scope.chart = $scope.drawChart();
      }, 100)
    }
  };
  $scope.modalHeader = "Sunday Attendance";
  $scope.subHeader = "Last 12 Months";
  $scope.compareGrouping = "region";
  $scope.chartAttr = 'sunday';
  $scope.cardName = "Last 12 months"
  $scope.setBaseChartData = function(){
    $scope.chartData = [];
    $scope.drilldownData = [];
    var j = 0;
    for (var region in $scope.allData.totals_by_region){
      var reg = $scope.allData.totals_by_region[region];
      $scope.chartData.push({name: region, y: +$scope.allData.totals_by_region[region]["Last 12 months"].sunday, drilldown: region})
      $scope.drilldownData.push({id: region, data: []})
      for (var i=0; i < reg.groups.length; i++){
        $scope.drilldownData[j].data.push({
          name: reg.groups[i],
          y: +$scope.allData.totals_by_group[reg.groups[i]]["Last 12 months"].sunday, drilldown: reg.groups[i]
        })
      }
      j += 1;
    }
  };
  $scope.drawChart = function(options){
    return new Highcharts.chart({
        credits: {
          enabled: false
        },
        chart: {
            type: 'bar',
            renderTo: 'chartContainer',
            plotBackgroundColor: null,
            plotBorderWidth: 0,
            plotShadow: false
        },
        xAxis: {
            type: 'category',
             // categories: $scope.chartData.filter(function(ele){ return ele.y > 0}).map(function(ele){return ele.name + " - " + ele.y;}),
             // title: {
             //     text: null
             // },
             // labels: {
             //  style: {color: '#a9a9a9', fontSize: '14px'}
             // }
         },
        yAxis: {
          title: {
            text: null
          },
          lineWidth: 0,
          gridLineWidth: 0,
          minorGridLineWidth: 0,
          lineColor: 'transparent',
             labels: {
               enabled: false
             },
          minorTickLength: 0,
          tickLength: 0
        },
        legend: {
            enabled: false,
            layout: 'vertical',
            verticalAlign: 'middle',
            align: 'right',
            itemStyle: {
                color: 'white',
                fontWeight: 'bold',
                fontSize: '14px',
            }
        },
        title: {
            text: $scope.modalHeader.replace(/&amp;/g, '&'),
            margin: 20,
            style: {color: '#f9f9f9'}
        },
        subtitle: {
            text: $scope.subHeader,
            style: {color: '#c9c9c9'}
        },
        tooltip: {
            pointFormat: '{series.name}: <b>{point.y:.0f}</b>'
        },
        plotOptions: {
          bar: {
            dataLabels: {
              enabled: true,
              align: 'left',
              style: {
                color: '#f9f9f9',
                fontWeight: 'normal',
                fontSize: '14px'
              }
            }
          }
        },
        series: [{
          // name: 'Main',
          colorByPoint: true,
          // type: 'column',
          name: $scope.modalHeader.replace(/&amp;/, '&'),
          data: $scope.chartData.filter(function(ele){return ele.y > 0 })
          // data: $scope.chartData.filter(function(ele){return ele['y'] > 0 })
        }],
        drilldown: {
          activeAxisLabelStyle: { "cursor": "pointer", "color": "#a9a9a9", "fontWeight": "bold", "textDecoration": "none" },
          series: $scope.drilldownData
        }
    });
  }


  $scope.drawTrendChart = function(options){
    return new Highcharts.chart({
        credits: {
          enabled: false
        },
        chart: {
            renderTo: 'trendChartContainer',
            plotBackgroundColor: null,
            plotBorderWidth: 0,
            plotShadow: false
        },
        xAxis: {
             categories: $scope.lastTwelve.map(function(ele){return ele[0]}),
             title: {
                 text: null
             },
             labels: {
              style: {size: '#a9a9a9', fontSize: '12px'}
             }
         },
        yAxis: {
          title: {
            text: null
          },
          lineWidth: 0,
          gridLineWidth: 0,
          minorGridLineWidth: 0,
          lineColor: 'transparent',
             labels: {
               enabled: false
             },
          minorTickLength: 0,
          tickLength: 0
        },
        legend: {
            enabled: true,
            layout: 'horizontal',
            verticalAlign: 'bottom',
           
            align: 'right',
            itemStyle: {
                color: 'white',
                fontWeight: 'bold',
                fontSize: '14px',
            }
        },
        title: {
            text: $scope.trendChartHeader.replace(/&amp;/g, '&'),
            margin: 20,
            style: {color: '#f9f9f9'}
        },
        subtitle: {
            text: $scope.trendChartSubheader,
            style: {color: '#c9c9c9'}
        },
        tooltip: {
            pointFormat: '{series.name}: <b>{point.y:.0f}</b>'
        },
        plotOptions: {
            column: {
              dataLabels: {
                enabled: true,
                align: 'center',
                style: {
                  color: '#f9f9f9',
                  fontWeight: 'normal',
                  fontSize: '14px'
                }
              }
            }
        },
        series: [{
          colorByPoint: true,
          type: 'column',
          name: $scope.trendChartHeader,
          data: $scope.trendData.filter(function(ele){return ele[1] > 0 })
        }]
    });
  }
  setTimeout($scope.getMasterJSON, 100);
  $scope.clearCache = function(){
    if (isLocalStorageNameSupported()){
      window.localStorage.clear();
      window.location.reload();
    }
  }
}])
