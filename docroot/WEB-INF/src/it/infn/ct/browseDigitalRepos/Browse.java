/*
*************************************************************************
Copyright (c) 2011-2015:
Istituto Nazionale di Fisica Nucleare (INFN), Italy
Consorzio COMETA (COMETA), Italy

See http://www.infn.it and and http://www.consorzio-cometa.it for details on
the copyright holders.

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
***************************************************************************
*/
package it.infn.ct.browseDigitalRepos;

// import liferay libraries
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.model.Company;

// import DataEngine libraries
import com.liferay.portal.util.PortalUtil;

// import generic Java libraries
import java.io.IOException;
import java.util.Arrays;
import java.util.logging.Level;
import java.util.logging.Logger;

// import portlet libraries
import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.GenericPortlet;
import javax.portlet.PortletException;
import javax.portlet.PortletMode;
import javax.portlet.PortletPreferences;
import javax.portlet.PortletRequestDispatcher;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;

// Importing Apache libraries
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class Browse extends GenericPortlet {

    private static Log log = LogFactory.getLog(Browse.class);   

    @Override
    protected void doEdit(RenderRequest request,
            RenderResponse response)
            throws PortletException, IOException
    {

        PortletPreferences portletPreferences =
                (PortletPreferences) request.getPreferences();

        response.setContentType("text/html");
                
        String eumed_browse_INFRASTRUCTURE = portletPreferences.getValue("eumed_browse_INFRASTRUCTURE", "N/A");
        String eumed_browse_VONAME = portletPreferences.getValue("eumed_browse_VONAME", "N/A");
        String eumed_browse_LAT = portletPreferences.getValue("eumed_browse_LAT", "37.525809");
        String eumed_browse_ETOKENSERVER = portletPreferences.getValue("eumed_browse_ETOKENSERVER", "N/A");
        String eumed_browse_LONG = portletPreferences.getValue("eumed_browse_LONG", "15.073628");
        String eumed_browse_PORT = portletPreferences.getValue("eumed_browse_PORT", "N/A");
        String eumed_browse_ROBOTID = portletPreferences.getValue("eumed_browse_ROBOTID", "N/A");
        String eumed_browse_ROLE = portletPreferences.getValue("eumed_browse_ROLE", "N/A");
        
        String browse_METADATA_HOST = portletPreferences.getValue("browse_METADATA_HOST", "N/A");
        String repository = portletPreferences.getValue("repository", "N/A");
        
        String[] infras = portletPreferences.getValues("browse_ENABLEINFRASTRUCTURE", new String[2]);

        // Set the default portlet preferences
        request.setAttribute("eumed_browse_INFRASTRUCTURE", eumed_browse_INFRASTRUCTURE.trim());
        request.setAttribute("eumed_browse_VONAME", eumed_browse_VONAME.trim());
        request.setAttribute("eumed_browse_LAT", eumed_browse_LAT.trim());
        request.setAttribute("eumed_browse_ETOKENSERVER", eumed_browse_ETOKENSERVER.trim());
        request.setAttribute("eumed_browse_LONG", eumed_browse_LONG.trim());
        request.setAttribute("eumed_browse_PORT", eumed_browse_PORT.trim());
        request.setAttribute("eumed_browse_ROBOTID", eumed_browse_ROBOTID.trim());
        request.setAttribute("eumed_browse_ROLE", eumed_browse_ROLE.trim());
        
        request.setAttribute("browse_ENABLEINFRASTRUCTURE", infras);
        request.setAttribute("browse_METADATA_HOST", browse_METADATA_HOST.trim());
        request.setAttribute("repository", repository.trim());        
        
        log.info("\nStarting the EDIT mode...with this settings"
        + "\n\neumed_browse_INFRASTRUCTURE: " + eumed_browse_INFRASTRUCTURE
        + "\neumed_browse_VONAME: " + eumed_browse_VONAME
        + "\neumed_browse_LAT: " + eumed_browse_LAT
        + "\neumed_browse_LONG: " + eumed_browse_LONG
        + "\neumed_browse_ETOKENSERVER: " + eumed_browse_ETOKENSERVER        
        + "\neumed_browse_PORT: " + eumed_browse_PORT
        + "\neumed_browse_ROBOTID: " + eumed_browse_ROBOTID
        + "\neumed_browse_ROLE: " + eumed_browse_ROLE
                
        + "\nbrowse_METADATA_HOST: " + browse_METADATA_HOST
        + "\nrepository: " + repository);        

        PortletRequestDispatcher dispatcher =
                getPortletContext().getRequestDispatcher("/edit.jsp");

        dispatcher.include(request, response);
    }

    @Override
    protected void doHelp(RenderRequest request, RenderResponse response)
            throws PortletException, IOException {
        //super.doHelp(request, response);

        response.setContentType("text/html");

        log.info("\nStarting the HELP mode...");
        PortletRequestDispatcher dispatcher =
                getPortletContext().getRequestDispatcher("/help.jsp");

        dispatcher.include(request, response);
    }

    @Override
    protected void doView(RenderRequest request, RenderResponse response)
            throws PortletException, IOException {

        PortletPreferences portletPreferences =
                (PortletPreferences) request.getPreferences();

        response.setContentType("text/html");

        //java.util.Enumeration listPreferences = portletPreferences.getNames();
        PortletRequestDispatcher dispatcher = null;
        
        String eumed_browse_LAT = "";
        String eumed_browse_VONAME = "";
        String eumed_browse_ENABLEINFRASTRUCTURE = "";
        String[] infras = new String[1];
        
        String[] browse_INFRASTRUCTURES = 
                portletPreferences.getValues("browse_ENABLEINFRASTRUCTURE", new String[2]);
        
        for (int i=0; i<browse_INFRASTRUCTURES.length; i++) {            
            if (browse_INFRASTRUCTURES[i]!=null && browse_INFRASTRUCTURES[i].equals("eumed")) 
                { eumed_browse_ENABLEINFRASTRUCTURE = "checked"; log.info ("\n EUMED!"); }        
        }
        
        String browse_METADATA_HOST = portletPreferences.getValue("browse_METADATA_HOST", "N/A");
        String repository = portletPreferences.getValue("repository", "N/A");        
                        
        if (eumed_browse_ENABLEINFRASTRUCTURE.equals("checked"))
        {
            infras[0]="eumed";
            String eumed_browse_INFRASTRUCTURE = portletPreferences.getValue("eumed_browse_INFRASTRUCTURE", "N/A");
            eumed_browse_VONAME = portletPreferences.getValue("eumed_browse_VONAME", "N/A");
            eumed_browse_LAT = portletPreferences.getValue("eumed_browse_LAT", "37.525809");
            String eumed_browse_ETOKENSERVER = portletPreferences.getValue("eumed_browse_ETOKENSERVER", "N/A");
            String eumed_browse_LONG = portletPreferences.getValue("eumed_browse_LONG", "15.073628");
            String eumed_browse_PORT = portletPreferences.getValue("eumed_browse_PORT", "N/A");
            String eumed_browse_ROBOTID = portletPreferences.getValue("eumed_browse_ROBOTID", "N/A");
            String eumed_browse_ROLE = portletPreferences.getValue("eumed_browse_ROLE", "N/A");
                                    
            // Save the portlet preferences
            request.setAttribute("eumed_browse_INFRASTRUCTURE", eumed_browse_INFRASTRUCTURE.trim());
            request.setAttribute("eumed_browse_VONAME", eumed_browse_VONAME.trim());
            request.setAttribute("eumed_browse_LAT", eumed_browse_LAT.trim());
            request.setAttribute("eumed_browse_ETOKENSERVER", eumed_browse_ETOKENSERVER.trim());
            request.setAttribute("eumed_browse_LONG", eumed_browse_LONG.trim());
            request.setAttribute("eumed_browse_PORT", eumed_browse_PORT.trim());
            request.setAttribute("eumed_browse_ROBOTID", eumed_browse_ROBOTID.trim());
            request.setAttribute("eumed_browse_ROLE", eumed_browse_ROLE.trim());
            
            request.setAttribute("browse_METADATA_HOST", browse_METADATA_HOST.trim());
            request.setAttribute("repository", repository.trim());            
        }                                
        
        // Save in the preferences the list of supported infrastructures 
        request.setAttribute("browse_ENABLEINFRASTRUCTURE", infras);

        dispatcher = getPortletContext().getRequestDispatcher("/view.jsp");       
        dispatcher.include(request, response);
    }

    // The init method will be called when installing for the first time the portlet
    // This is the right time to setup the default values into the preferences
    @Override
    public void init() throws PortletException {
        super.init();
    }

    @Override
    public void processAction(ActionRequest request,
                              ActionResponse response)
                throws PortletException, IOException 
    {
        try {
            String action = "";

            // Getting the action to be processed from the request
            action = request.getParameter("ActionEvent");

            Company company = PortalUtil.getCompany(request);
            String portal = company.getName();

            PortletPreferences portletPreferences =
                    (PortletPreferences) request.getPreferences();

            if (action.equals("CONFIG_BROWSE_PORTLET")) {
                log.info("\nPROCESS ACTION => " + action);
                
                String browse_METADATA_HOST = request.getParameter("browse_METADATA_HOST");
                String repository = request.getParameter("repository");
                String[] infras = new String[2];
                
                String eumed_browse_ENABLEINFRASTRUCTURE = "unchecked";                
                String[] browse_INFRASTRUCTURES = request.getParameterValues("browse_ENABLEINFRASTRUCTURES");         

                if (browse_INFRASTRUCTURES != null) {
                    Arrays.sort(browse_INFRASTRUCTURES);
                    eumed_browse_ENABLEINFRASTRUCTURE =
                        Arrays.binarySearch(browse_INFRASTRUCTURES, "eumed") >= 0 ? "checked" : "unchecked";                    
                }                                               

                if (eumed_browse_ENABLEINFRASTRUCTURE.equals("checked"))
                {
                    infras[0]="eumed";
                    String eumed_browse_INFRASTRUCTURE = request.getParameter("eumed_browse_INFRASTRUCTURE");
                    String eumed_browse_VONAME = request.getParameter("eumed_browse_VONAME");
                    String eumed_browse_LAT = request.getParameter("eumed_browse_LAT");
                    String eumed_browse_ETOKENSERVER = request.getParameter("eumed_browse_ETOKENSERVER");
                    String eumed_browse_LONG = request.getParameter("eumed_browse_LONG");
                    String eumed_browse_PORT = request.getParameter("eumed_browse_PORT");
                    String eumed_browse_ROBOTID = request.getParameter("eumed_browse_ROBOTID");
                    String eumed_browse_ROLE = request.getParameter("eumed_browse_ROLE");                    

                    // Set the portlet preferences
                    portletPreferences.setValue("eumed_browse_INFRASTRUCTURE", eumed_browse_INFRASTRUCTURE.trim());
                    portletPreferences.setValue("eumed_browse_VONAME", eumed_browse_VONAME.trim());
                    portletPreferences.setValue("eumed_browse_LAT", eumed_browse_LAT.trim());
                    portletPreferences.setValue("eumed_browse_ETOKENSERVER", eumed_browse_ETOKENSERVER.trim());
                    portletPreferences.setValue("eumed_browse_LONG", eumed_browse_LONG.trim());
                    portletPreferences.setValue("eumed_browse_PORT", eumed_browse_PORT.trim());
                    portletPreferences.setValue("eumed_browse_ROBOTID", eumed_browse_ROBOTID.trim());
                    portletPreferences.setValue("eumed_browse_ROLE", eumed_browse_ROLE.trim());
                    
                    portletPreferences.setValue("browse_METADATA_HOST", browse_METADATA_HOST.trim());
                    portletPreferences.setValue("repository", repository.trim());                    
                    
                    log.info("\n\nPROCESS ACTION => " + action
                        + "\n- Storing the BROWSE portlet preferences ..."                    
                        + "\n\neumed_browse_INFRASTRUCTURE: " + eumed_browse_INFRASTRUCTURE
                        + "\neumed_browse_VONAME: " + eumed_browse_VONAME
                        + "\neumed_browse_LAT: " + eumed_browse_LAT
                        + "\neumed_browse_LONG: " + eumed_browse_LONG
                        + "\neumed_browse_ETOKENSERVER: " + eumed_browse_ETOKENSERVER                        
                        + "\neumed_browse_PORT: " + eumed_browse_PORT
                        + "\neumed_browse_ROBOTID: " + eumed_browse_ROBOTID
                        + "\neumed_browse_ROLE: " + eumed_browse_ROLE

                        + "\n\nbrowse_ENABLEINFRASTRUCTURE: " + "eumed"                        
                        + "\nbrowse_METADATA_HOST: " + browse_METADATA_HOST
                        + "\nRepository: " + repository);
                    }                
                
                for (int i=0; i<infras.length; i++)
                log.info("\n - Infrastructure Enabled = " + infras[i]);
                portletPreferences.setValues("browse_ENABLEINFRASTRUCTURE", infras);
                portletPreferences.setValue("eumed_browse_ENABLEINFRASTRUCTURE", infras[0]);                

                portletPreferences.store();
                response.setPortletMode(PortletMode.VIEW);
            } // end PROCESS ACTION [ CONFIG_BROWSE_PORTLET ]
                       
        } catch (PortalException ex) {
            Logger.getLogger(Browse.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SystemException ex) {
            Logger.getLogger(Browse.class.getName()).log(Level.SEVERE, null, ex);
        }
    }       
}
