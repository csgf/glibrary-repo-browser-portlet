***************************
GLIBRARY-REPO-BROWSER-PORTLET
***************************

============
About
============

.. image:: images/ABINIT_logo.png
   :height: 100px
   :align: left
   :target: http://www.abinit.org/
-------------

.. _ABINIT: http://www.abinit.org/
.. _DFT: http://dft.sandia.gov/

ABINIT_ is a package whose main program allows one to find the total energy, charge density and electronic structure of systems made of electrons and nuclei (molecules and periodic solids) within Density Functional Theory (DFT_), using pseudopotentials and a planewave or wavelet basis. 

ABINIT_ also includes options to optimize the geometry according to the DFT_ forces and stresses, or to perform molecular dynamics simulations using these forces, or to generate dynamical matrices, Born effective charges, and dielectric tensors, based on Density-Functional Perturbation Theory, and many more properties. 

Excited states can be computed within the Many-Body Perturbation Theory (the GW approximation and the Bethe-Salpeter equation), and Time-Dependent Density Functional Theory (for molecules). In addition to the main ABINIT_ code, different utility programs are provided. 

ABINIT_ is a project that favours development and collaboration `(short presentation of the ABINIT project) <http://www.abinit.org/about/presentation.pdf>`_.

============
Installation
============
To install the abinitDM portlet the WAR file has to be deployed into the application server.

As soon as the portlet has been successfully deployed on the Science Gateway the administrator has to configure:

- the list of e-Infrastructures where the application can be executed;

- some additional application settings.

1.) To configure a generic e-Infrastructure, the following settings have to be provided:

**Enabled**: A true/false flag which enables or disable the generic e-Infrastructure;

**Infrastructure**: The acronym to reference the e-Infrastructure;

**VOName**: The VO for this e-Infrastructure;

**eTokenServer**: The eTokenServer for this e-Infrastructure;

**Port**: The eTokenServer port for this e-Infrastructure;

**Serial Number**: The MD5SUM of the robot certificate to be used for this e-Infrastructure;

In the following figure is shown how the portlet has been configured to run simulation on the EUMEDGRID-Support e-Infrastructure.

.. image:: images/ABINIT_settings.jpg
   :align: center

2.) To configure the application, the following settings have to be provided:

**Proxy**: The proxy used to contact gLibrary;

**Repository**: The digital repository to browse;

**LAT**: The default latitude of the EMI-3 DPM Storage Element;

**LONG**: The default longitude of the EMI-3 DPM Storage Element.

.. _CHAIN-REDS: https://science-gateway.chain-project.eu/
.. _gLibrary: https://glibrary.ct.infn.it/

In the figure below is shown how the portlet has been configured to browse the **ESArep** digital repository.

.. image:: images/ABINIT_settings2.jpg
   :align: center

============
Usage
============
The run abinit simulation the user has to click on the third accordion, select the type of job to run (e.g. *'Sequential'* or *'Parallel'*)
and upload the input files.


============
Contributor(s)
============
Please feel free to contact us any time if you have any questions or comments.

.. _INFN: http://www.ct.infn.it/

:Authors:
 Giuseppe LA ROCCA - Italian National Institute of Nuclear Physics (INFN_),

 Mario TORRISI - University of Catania (DFA_),

