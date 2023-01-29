CLASS zcl_export_template_util DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .


  PUBLIC SECTION.
    CLASS-METHODS: get_file
      IMPORTING
        im_obj_name   TYPE tadir-obj_name
        filename      TYPE rlgrap-filename OPTIONAL
      RETURNING
        VALUE(return) TYPE bapireturn.
PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_export_template_util IMPLEMENTATION.
  METHOD get_file.


* Global data declarations
    DATA: ls_wwwdata_tab TYPE wwwdatatab.

*Make sure template exists in SMw0 as binary object
    SELECT * FROM wwwdata INNER JOIN tadir
                  ON wwwdata~objid = tadir~obj_name
                  INTO  CORRESPONDING FIELDS OF ls_wwwdata_tab UP TO 1 ROWS
                  WHERE wwwdata~srtf2 EQ 0
                  AND   wwwdata~relid EQ 'MI'
                  AND   tadir~pgmid    EQ 'R3TR'
                  AND   tadir~object   EQ 'W3MI'
                  AND   tadir~obj_name EQ im_obj_name. "This is the object name in tcode smw0
    ENDSELECT.

    IF  ls_wwwdata_tab IS INITIAL.
      return-type        = 'E'.
      return-message_v1  = 'Template'.
      return-message_v2  = im_obj_name.
      return-message_v3  = 'does not exist in'.
      return-message_v4  = 'transaction SMW0'.
    ELSE.
      IF filename IS NOT INITIAL.
        CALL FUNCTION 'DOWNLOAD_WEB_OBJECT'
          EXPORTING
            key         = ls_wwwdata_tab
            destination = filename.
      ELSE.
        CALL FUNCTION 'DOWNLOAD_WEB_OBJECT'
          EXPORTING
            key = ls_wwwdata_tab.
      ENDIF.
    ENDIF.


  ENDMETHOD.

ENDCLASS.
