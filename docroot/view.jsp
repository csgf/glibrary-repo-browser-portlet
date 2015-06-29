<%
/**************************************************************************
Copyright (c) 2011-2015:
Istituto Nazionale di Fisica Nucleare (INFN), Italy
Consorzio COMETA (COMETA), Italy
    
See http://www.infn.it and and http://www.consorzio-lato.it for details 
on the copyright holders.
    
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
    
http://www.apache.org/licenses/LICENSE-2.0
    
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
    
@author <a href="mailto:giuseppe.larocca@ct.infn.it">Giuseppe La Rocca</a>
**************************************************************************/
%>
<%@ page import="com.liferay.portal.kernel.util.WebKeys" %>
<%@ page import="com.liferay.portal.util.PortalUtil" %>
<%@ page import="com.liferay.portal.model.Company" %>
<%@ page import="javax.portlet.*" %>
<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet" %>
<%@ taglib uri="http://liferay.com/tld/theme" prefix="liferay-theme" %>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<portlet:defineObjects/>

<%
  Company company = PortalUtil.getCompany(request);
  String gateway = company.getName();
%>

<jsp:useBean id="GPS_table" class="java.lang.String" scope="request"/>
<jsp:useBean id="GPS_queue" class="java.lang.String" scope="request"/>

<jsp:useBean id="eumed_browse_INFRASTRUCTURE" class="java.lang.String" scope="request"/>
<jsp:useBean id="eumed_browse_VONAME" class="java.lang.String" scope="request"/>
<jsp:useBean id="eumed_browse_LAT" class="java.lang.String" scope="request"/>
<jsp:useBean id="eumed_browse_LONG" class="java.lang.String" scope="request"/>
<jsp:useBean id="eumed_browse_ETOKENSERVER" class="java.lang.String" scope="request"/>
<jsp:useBean id="eumed_browse_PORT" class="java.lang.String" scope="request"/>
<jsp:useBean id="eumed_browse_ROBOTID" class="java.lang.String" scope="request"/>
<jsp:useBean id="eumed_browse_ROLE" class="java.lang.String" scope="request"/>

<jsp:useBean id="browse_ENABLEINFRASTRUCTURE" class="java.lang.String[]" scope="request"/>
<jsp:useBean id="browse_APPID" class="java.lang.String" scope="request"/>
<jsp:useBean id="browse_METADATA_HOST" class="java.lang.String" scope="request"/>
<jsp:useBean id="repository" class="java.lang.String" scope="request"/>

<script type="text/javascript">
    
 // ---------------------------------------------------------
 function example ()
 {
    var myDiv = Ext.get('gLibtestDiv');        
    // Skip protocol from the METADATA_HOST (if any)
    //var metadata_host = '<%= browse_METADATA_HOST %>'.replace('http://', '').replace('https://','')
    //var urlServer='/glibrary/';
    var urlServer='/'+ '<%= browse_METADATA_HOST %>' + '/';
    
    //var repo='GROMACS';
    var repo = '<%= repository %>'
    console.log("Repository = " + repo);
    
    console.log("Metadata Server = " + urlServer);  
    
    console.log("LAT = " + '<%= eumed_browse_LAT %>');
    console.log("LONG = " + '<%= eumed_browse_LONG %>');
  
    var proxy = new Ext.data.ScriptTagProxy( { url: urlServer+'glib/miguel/' } );
    var reader= new Ext.data.JsonReader({
    root: 'records',
	totalProperty: 'total',
    fields:[
	  { name : 'Name', mapping : 'Name' },
	  { name : 'Surname', mapping : 'Surname' },
      { name : 'Age', mapping : 'Age' },
      { name : 'Direction', mapping : 'Direction' }
    ]
    });
  
    var store=new Ext.data.Store({
        id : 'ourRemoteStore',
        proxy: proxy,
            reader: reader
    });
  
    var pagingToolbar = { //1
        xtype : 'paging',
        store : store,
        pageSize : 3,
        displayInfo : true
    }
    
    /*var grid = new Ext.grid.GridPanel({
        store: store,
	bbar : pagingToolbar,
	columns: [
	  {
	    header: 'First Name',
		width: 100,
		dataIndex: 'Name',
		sortable: true
	  },
	  {
	    header: 'Last Name',
		width: 100,
		dataIndex: 'Surname',
		sortable: true
	  },
	  {
	    header: 'Age',
		width: 60,
		dataIndex: 'Age',
		sortable: true
	  },
	  {
	    header: 'Address',
		width: 120,
		dataIndex: 'Direction',
		sortable: true
	  }
	],
	//renderTo: myDiv,
	width: 400,
	height: 200
    });*/
  
    var tree = new Ext.tree.TreePanel({
	//xtype : 'treepanel',
	autoScroll : true,
	loader : new Ext.tree.TreeLoader({ // 1
            url : urlServer + 'mountTree/' + repo + '/', //getTree
            requestMethod: 'GET',
            preloadChildren: true
	}),
	root : new Ext.tree.AsyncTreeNode({ // 2	  
            text : '<%= repository %> Repository',
            id : '0', // deroberto/Entries
            expanded : true
	}),
	height: 250
    });
  
    var win=new Ext.Window({
        title: tree.root.text,
	width: 100,
	height: 50,
	layout: 'fit'
    });        
  
    /*var colProxy = new Ext.data.ScriptTagProxy( { url: 'http://glibrary.ct.infn.it:8000/test/' } );
    var colReader= new Ext.data.JsonReader();
  
    var colStore=new Ext.data.Store({
        id : 'colStore',
        proxy: colProxy,
	reader: colReader
    }).load();
  
    //console.log('metada-> '+colReader.meta.fields);
    var colGrid = new Ext.grid.GridPanel({
        store: colStore,
	columns: colReader.meta.fields,
	//renderTo: myDiv,
	width: 400,
	height: 200
    });*/

    var colGrid,colStore,colReader;
  
    function renderIcon(val) 
    {    
        return '<img src="data:image/jpg;base64,'+val+'" height="32"> '+'</a>';
    }
  
    function columnWrap(val)
    {
        return '<div style="white-space:normal !important; font-family: verdana;">'+ val +'</div>';
    }
  
    tree.on('click', function(n)
    {
        var sn = this.selModel.selNode || {}; // selNode is null on initial selection
        if(n.id != sn.id){  // ignore clicks on folders and currently selected node  //n.leaf &&
	  //console.log(n.text+'->'+n.id+'--'+n.attributes.path);
	  
	  //if(n.id==1)
	  {
	    Ext.Ajax.request({  
            url: urlServer+'metadata'+n.attributes.path+'/',  
            method: 'GET',
            success: successAjaxFn=function(response, request) {
                var jsonData = Ext.util.JSON.decode(response.responseText);
		//console.log('jsonData-> '+jsonData.metadata.fields);
			   
		var jsonReader = new Ext.data.JsonReader(jsonData.metadata);
		var memoryProxy = new Ext.data.ScriptTagProxy( { url: urlServer+'glib'+n.attributes.path+'/' } );
		var colStore=new Ext.data.Store({
                    id : 'colStore',
                    reader: jsonReader, //data: arrayData,
                    proxy: memoryProxy,
                    sortInfo: {
                        field: 'SubmissionDate',
                        direction: 'DESC' // or 'DESC' (case sensitive for local sorting)
                    } //fields: ['FileName','TypeID','CategoryIDs']
		    //reader: colReader=new Ext.data.JsonReader(jsonData.metadata)
		});
		
                var colToolbar = { //1
                    xtype : 'paging',
                    store : colStore,
                    pageSize : 50,
                    displayInfo : true
		}
                    colStore.load({ // 2
                        params : {
                            start : 0,
                            limit : 50
			}
                    });
				 
		var j,arrayData;
		for (j=0;j<jsonData.filters.length;j++){
                    if(jsonData.filters[j].type==='list'){
                        arrayData= jsonData.filters[j].filterList;
			jsonData.filters[j].store= new Ext.data.ArrayStore({
			//data : arrayData,
			id: '0',
			fields : [jsonData.filters[j].labelField],
			proxy: new Ext.data.MemoryProxy(arrayData)
                        });
                    }
		}
		
                var filters = new Ext.ux.grid.GridFilters({
		// encode and local configuration options defined previously for easier reuse
		//encode: encode, // json encode the filter query
		//local: true,   // defaults to false (remote filtering)
		filters: jsonData.filters
		});
				 
		//if(colGrid===undefined){
		colGrid = new Ext.grid.GridPanel({
                    bbar: colToolbar,
                    store: colStore,
                    columns: jsonData.columns,
                    loadMask: true,
                    plugins: [filters],
                    //renderTo: myDiv,
                    width: 400,
                    height: 200
		});
			   
		var column=colGrid.getColumnModel().getColumnById('thumb');
                
		if (column) column.renderer=renderIcon;			
			   
                colGrid.on('rowclick', function(colGrid, rowIndex, e) {
                    var record = colGrid.getStore().getAt(rowIndex);
                    //console.log('row->'+record.get(n.attributes.path+':FILE'));

                    var mapwin=Ext.getCmp('myMapWin');
                    if(!mapwin){
                        mapwin = new Ext.Window({
                            id: 'myMapWin',
                            layout: 'fit',
                            title: 'Select the replica to download...',
                            closeAction: 'hide',
                            x: 200,
                            y: 100,
                            width: 800,
                            height: 500,
                            //items: earthPanel
                            items: {
                                xtype: 'gmappanel',
				id: 'my-map',
				zoomLevel: 16,
				gmapType: 'map',
				mapConfOpts: ['enableScrollWheelZoom','enableDoubleClickZoom','enableDragging'],
				mapControls: ['GSmallMapControl','GMapTypeControl','NonExistantControl'],
				setCenter: {
                                    // set center 
                                    //lat: 37.525809,
                                    lat : '<%= eumed_browse_LAT %>',                                    
                                    //lng: 15.073628
                                    lng : '<%= eumed_browse_LONG %>'
				}
                            }
                        });
			
                        var map=Ext.getCmp('my-map');
			map.on('mapready', function() {
                            console.log("mapready");
                            map.showMarkers();
			});
                    }
                                
                    //mapwin.show();
                    //var map=Ext.getCmp('my-map');
                    //map.hideAllInfoWindows();

                    Ext.Ajax.request({
                        url: urlServer+'links2/'+repo+'/'+record.get(n.attributes.path+':FILE')+'/',
			method: 'GET',
			success: successFn=function(response, request) {
                            var jsonLinks = Ext.util.JSON.decode(response.responseText);
                            var map=Ext.getCmp('my-map');
                            //map.cache.marker.length = 0;
                            map.hideAllInfoWindows();
                            map.clearMarkers();
                            //console.log(jsonLinks);
                            var markers = [];
                            //var enableSEicon = "http://glibrary.ct.infn.it/glibrary_new/images/data_storage_verde.png";
                            //var enableSEicon = "http://" + metadata_host + "/glibrary_new/images/data_storage_verde.png";
                            var enableSEicon = '<%= renderRequest.getContextPath()%>/images/data_storage_verde.png'
                            //var disabledSEicon = "http://glibrary.ct.infn.it/glibrary_new/images/data_storage_rosso.png"
                            //var disabledSEicon = "http://" + metadata_host + "/glibrary_new/images/data_storage_rosso.png"
                            var disabledSEicon = '<%= renderRequest.getContextPath()%>/images/data_storage_rosso.png'
			
                            for (i=0; i< jsonLinks.length; i++) {
                                markers[i] = {
                                    lat: jsonLinks[i].lat,
                                    lng: jsonLinks[i].lng,
				marker: {
                                    title: jsonLinks[i].name,
                                    infoWindow: {content: jsonLinks[i].link},
				icon: {
                                    url: jsonLinks[i].enabled === "0"? disabledSEicon : enableSEicon,
                                    scaledSize: {width:40, height:40}
				}
                                }
				}
                            }
                            
                            //console.log("sono qui");
                            //console.log(markers);
                            //map.addMarkers(markers);
                            // clear the previous markers
                            //map.addMarker(false, false, true, false, false);
                            mapwin.show();
                            map.addMarkers(markers);									
                        },  
			
                        failure: failureFn=function(response, request) {
                            console.log('Error!');                            
			},
			timeout: 10000,
			params: {  
                            //node: '1'
			}
                    });
               });
			   
               var i,filtro,boton;
               colGrid.on('filterupdate',function() 
               {
               
                for (i=0;i<colGrid.filters.getFilterData().length;i++)
                {
                    //console.log('filtro['+i+']'+colGrid.filters.getFilterData()[i].field);
                    filtro = colGrid.filters.getFilterData()[i];
                    boton=Ext.getCmp(filtro.field);
                    if(boton!==undefined)
                        boton.setText(filtro.field+'('+filtro.data.value+')');
                    else
			colGrid.getBottomToolbar().add([
                    {
                        text: filtro.field+'('+filtro.data.value+')',
			id: filtro.field,
			handler: function () {
                            //console.log('quitar filtro '+this.getText());
                            colGrid.filters.getFilter(this.getId()).setActive(false,false);
                            colGrid.getBottomToolbar().remove(this,true);
			}
                    }]);
                }
				 
		Ext.Ajax.request({
                    url: urlServer+'test'+n.attributes.path+'/',
                    method: 'GET',
                    success: successFn=function(response, request) {
                    var jsonArray = Ext.util.JSON.decode(response.responseText);
                    //if(jsonData.filters[i].labelField!=='filter'+filtro.field)
                    var vArray;
                    for (j=0;j<jsonData.filters.length;j++)
                    {
                        vArray=jsonArray[j];
			jsonData.filters[j].store.loadData(vArray);
                    }
                    },  
		
                    failure: failureFn=function(response, request) {
                        console.log('Error!');
                    },
		
                    timeout: 10000,
                    params: { 
                        filterName: jsonData.filters[0].dataIndex,
			filterData: Ext.util.JSON.encode(colGrid.filters.getFilterData())
                    }
                });
				 
		var centerReg=Ext.getCmp('center-region');
		centerReg.doLayout();
               });
			   
                colGrid.getBottomToolbar().add([
		'->',
		{
                    text: 'Clear All Filters',
                    handler: function () {
                        while(colGrid.filters.getFilterData().length > 0){
                            boton=Ext.getCmp(colGrid.filters.getFilterData()[0].field);
                            colGrid.getBottomToolbar().remove(boton);
                            colGrid.filters.getFilter(boton.getId()).setActive(false,false);
			}
			
                        var centerReg=Ext.getCmp('center-region');
			centerReg.doLayout();
					
			//colGrid.filters.clearFilters();
                    } 
		}]);
			   
		for (i=0;i<colGrid.getColumnModel().getColumnCount();i++)
		{
                    column=colGrid.getColumnModel().getColumnId(i);
                    if(column!=='thumb')
                        colGrid.getColumnModel().setRenderer(i,columnWrap);
                    //column.renderer=columnWrap;
		}
			   
		var centerReg=Ext.getCmp('center-region');
		centerReg.removeAll();
		centerReg.add(colGrid);
		centerReg.doLayout();
		//}
            },  
            
            failure: failureAjaxFn=function(response, request) {
                console.log('Error!');                
            },
            
            timeout: 10000,
                params: {  
                 //node: '1'
                }
         });
        }
    }
  });

  
  var myBorderPanel = new Ext.Panel({
    id: 'border-panel',
    renderTo: myDiv,
    //width: 1000,
    height: 700,
    title: '',
    layout: 'border',
    items: [/*{
        title: '',
        region: 'south',     // position for region
		id: 'south-region',
        height: 100,
        split: false,         // enable resizing
		collapsible: true,
		collapsed: true,
        //minSize: 75,         // defaults to 50
        //maxSize: 150,
        margins: '0 5 5 5'
    },*/{
        // xtype: 'panel' implied by default
        title: '',
        region:'west',
        margins: '5 0 0 5',
        width: 200,
        collapsible: true,   // make collapsible
        cmargins: '5 5 0 5', // adjust top margin when collapsed
        id: 'west-region-container',
        layout: 'fit',
		collapseMode : 'mini',
        //unstyled: true
		items: tree
    },{
        title: 'Center Region',
		id: 'center-region',
        region: 'center',     // center region is required, no width/height specified
        xtype: 'container',
        layout: 'fit',
        margins: '5 5 0 0'
		//items: grid
    }]
  });
  Ext.EventManager.onWindowResize(myBorderPanel.doLayout, myBorderPanel);
  
  /*Ext.StoreMgr.get('ourRemoteStore').load({ // 2
      params : {
        start : 0,
        limit : 3
      }
  });*/

}
    // ---------------------------------------------------------
    
    
    var EnabledInfrastructure = null;           
    var infrastructures = new Array();  
    var i = 0;    
    
    <c:forEach items="<%= browse_ENABLEINFRASTRUCTURE %>" var="current">
    <c:choose>
    <c:when test="${current!=null}">
        infrastructures[i] = '<c:out value='${current}'/>';       
        i++;  
    </c:when>
    </c:choose>
    </c:forEach>
        
    for (var i = 0; i < infrastructures.length; i++) {
       console.log("Reading array = " + infrastructures[i]);
       if (infrastructures[i]=="eumed")  EnabledInfrastructure='eumed';       
    }
    
    var NMAX = infrastructures.length;
    //console.log (NMAX);         

    $(document).ready(function() 
    {           
        console.log('before ext');
        Ext.onReady(example);
        console.log('after ext');        
        
        var lat; var lng; var zoom;
        var found=0;                
        
        if (parseInt(NMAX)>1) { 
            console.log ("More than one infrastructure has been configured!");
            $("#error_infrastructure img:last-child").remove();
            $('#error_infrastructure').append("<img width='70' src='<%= renderRequest.getContextPath()%>/images/world.png' border='0'> More than one infrastructure has been configured!");
            lat=30;lng=34;zoom=3; found=1;            
        } else if (EnabledInfrastructure=='eumed') {
            console.log ("Start up: enabled the eumed VO!");
            $('#eumed_browse_ENABLEINFRASTRUCTURE').attr('checked','checked');
            lat=34;lng=20;zoom=4;found=1;
        } 
        
        if (found==0) { 
            console.log ("None of the grid infrastructures have been configured!");
            $("#error_infrastructure img:last-child").remove();            
            $('#error_infrastructure').append("<img width='40' src='<%= renderRequest.getContextPath()%>/images/Warning.png' border='0'> None of the available infrastructures have been configured!");
        }
        
        var accOpts = {
            change: function(e, ui) {                       
                $("<div style='width:650px; font-family: Tahoma,Verdana,sans-serif,Arial; font-size: 14px;'>").addClass("notify ui-corner-all").text(ui.newHeader.find("a").text() +
                    " was activated... ").appendTo("#error_message").fadeOut(2500, function(){ $(this).remove(); });               
                // Get the active option                
                var active = $("#accordion").accordion("option", "active");
                if (active==1) initialize(lat, lng, zoom);
            },
            autoHeight: false
        };
                                 
        // Roller
        $('#browse_footer').rollchildren({
            delay_time         : 3000,
            loop               : true,
            pause_on_mouseover : true,
            roll_up_old_item   : true,
            speed              : 'slow'   
        });                
    });
                     
</script>

<br/>
<style type="text/css">
.folder-icon{background:transparent url('<%=renderRequest.getContextPath()%>/images/folder.gif') 0 0 no-repeat !important;}
</style>
<div id='gLibtestDiv'></div>

<div id="browse_footer" style="width:690px; font-family: Tahoma,Verdana,sans-serif,Arial; font-size: 14px;">    
    <div>The Italian National Institute of Nuclear Physics (INFN), Division of Catania, Italy</div>    
    <div>Copyright © 2015. All rights reserved</div>    
</div>               
