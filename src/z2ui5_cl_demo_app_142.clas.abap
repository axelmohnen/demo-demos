CLASS Z2UI5_CL_DEMO_APP_142 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_serializable_object .
    INTERFACES z2ui5_if_app .

    DATA check_initialized TYPE abap_bool .
  PROTECTED SECTION.

*    DATA imagemapster TYPE REF TO z2ui5_cl_cc_imagemapster.
*    DATA ls_mapster_config TYPE imagemapster->ty_imagemapster_config.


    METHODS z2ui5_on_rendering
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS z2ui5_on_event
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS z2ui5_on_init.

  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_142 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      z2ui5_on_init( ).

      client->view_display( z2ui5_cl_xml_view=>factory( client
        )->_z2ui5( )->timer(  client->_event( `START` )
          )->_generic( ns = `html` name = `script` )->_cc_plain_xml( z2ui5_cl_cc_imagemapster=>get_js_local( )
          )->stringify( ) ).

    ENDIF.

    z2ui5_on_event( client ).

  ENDMETHOD.


  METHOD z2ui5_on_event.

    CASE client->get( )-event.
      WHEN 'START'.
        z2ui5_on_rendering( client ).
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
      WHEN 'TEST'.
        client->message_toast_display( `Click on image map` ).
    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_on_init.
*    ls_mapster_config-stroke_color = `ff0000`.
*    ls_mapster_config-fill_color = `fcffa4`.
*    ls_mapster_config-fill_opacity = '0.8'.
*    ls_mapster_config-stroke = abap_true.
*    ls_mapster_config-stroke_opacity = `0.6`.
*    ls_mapster_config-stroke_width = `3`.
*    ls_mapster_config-single_select = abap_true.
  ENDMETHOD.


  METHOD z2ui5_on_rendering.




    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell(
         )->page(
          showheader       = xsdbool( abap_false = client->get( )-check_launchpad_active )
            title          = 'abap2UI5 - imagemap demo'
            navbuttonpress = client->_event( 'BACK' )
            enablescrolling = abap_false
              shownavbutton = abap_true ).

    page->header_content(
             )->link( text = 'Demo'        target = '_blank' href = `https://twitter.com/abap2UI5/status/1628701535222865922`
             )->link( text = 'Source_Code' target = '_blank' href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
         )->get_parent( ).


    page->vbox( )->image( src = `https://cdn.jsdelivr.net/gh/choper725/resources/dist/image_map_example.jpg`
                height = `100%`
                width = `100%`
                usemap = `#map_example`
                densityaware = abap_false
         )->html_map( id = `map_example` name = `map_example`
          )->html_area( id = `area_1`
                        shape = `poly`
                        coords = `65,210,280,101,576,435,363,564`
*                        target = `_blank`
                        href = `#`
                        onclick = `sap.z2ui5.oController.onEvent( { 'EVENT' : 'TEST', 'METHOD' : 'UPDATE' , 'CHECK_VIEW_DESTROY' : false })`
                    )->get_parent(
          )->html_area( id = `area_2`
                        shape = `poly`
                        coords = `406,151,473,138,501,193,438,209`
*                        target = `_blank`
                        href = `#`
                        onclick = `sap.z2ui5.oController.onEvent( { 'EVENT' : 'TEST', 'METHOD' : 'UPDATE' , 'CHECK_VIEW_DESTROY' : false })`
                  ).

    view->_generic( ns = `html` name = `script` )->_cc_plain_xml( z2ui5_cl_cc_imagemapster=>set_js_config( ) ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
