@echo off
title "3D AUTOMATIZADOR By arezZ"
COLOR F0
:inicio
SET opcion=0
COLOR F0
cls
::start https://www.youtube.com/c/arezZ-Tutoriales
@echo ------------------------------------------------------------------------------------------------------------------
@echo Este automatizador es para usuarios con conocimiento: medio/avanzado que solo quieren automatizar sus procesos 3D
@echo NOTA: Recuerda que algunos comandos no pueden ser usados en el firmware de fabrica de la artillery (EJEMPLO: G29)
@echo cambia de firmware (bajo tu propio riesgo) para poder usar dichos comandos
@echo ------------------------------------------------------------------------------------------------------------------
@echo Opciones disponibles:
@echo ------------------------------------------------------------------------------------------------------------------
@echo **************************************************
@echo *     1)  Checar puertos "COM"                   *
@echo *     2)  Visualizar informacion de firmware     *
@echo *     3)  Hacer homing                           *
@echo *     4)  Nivelar cama BLTOUCH                   *
@echo *     5)  Visualizar configuracion de impresora  *
@echo *     6)  Calibrar extrusor (Pasos)              *
@echo *     7)  Calibrar PID (Hotend)                  *
@echo *     8)  Calibrar PID (Cama)                    *
@echo *     9)  Deshabilitar motores                   *
@echo *     10) Encender Leds                          *
@echo *     11) Resetear EEPROM                        *
@echo *     12) Guardar EEPROM                         *
@echo *     13) Resetear BL-Touch                      *
@echo *     14) Precalentar Impresora                  *
@echo *     15) Mandar GCODE personalizado             *
@echo *     16) --Cambiar Firmware--                   *
@echo *     17) Salir                                  *
@echo **************************************************
@echo ------------------------------------------------------------------------------------------------------------------
SET /p opcion= ^> Seleccione una opcion [1-17]:
@echo ------------------------------------------------------------------------------------------------------------------
if "%opcion%"=="0" goto inicio
if "%opcion%"=="1" goto op1
if "%opcion%"=="2" goto op2
if "%opcion%"=="3" goto op3
if "%opcion%"=="4" goto op4
if "%opcion%"=="5" goto op5
if "%opcion%"=="6" goto op6
if "%opcion%"=="7" goto op7
if "%opcion%"=="8" goto op8
if "%opcion%"=="9" goto op9
if "%opcion%"=="10" goto op10
if "%opcion%"=="11" goto op11
if "%opcion%"=="12" goto op12
if "%opcion%"=="13" goto op13
if "%opcion%"=="14" goto op14
if "%opcion%"=="15" goto op15
if "%opcion%"=="16" goto op16
if "%opcion%"=="17" goto op17

@echo El numero "%var%" no es una opcion valida, por favor intente de nuevo
@echo.
pause
@echo.
goto:inicio
:: CUANDO HAGA LA ULTIMA COMPILACION CAMBIAR "python arezZ3D.py" por "arezZ3D.exe"
:op1
	cls
	COLOR 0F
	@echo ..............................
	@echo Puertos disponibles
	@echo ..............................
	::python -m serial.tools.list_ports
	python arezZ3D.py null PUERTOS
	SET /p puerto= ^> Escribe el puerto:
	@echo ..............................
	pause
	goto:inicio
:op2
	cls
	@echo ..............................
	@echo Ver informacion de firmware
	@echo ..............................
	IF "%puerto%"=="" @echo ERROR - INGRESA PRIMERO EL PUERTO COM && timeout /t 5 && goto op1
	python arezZ3D.py %puerto% M115
	@echo ..............................
	pause
	goto:inicio
:op3
	cls
	@echo ..............................
	@echo Hacer Homing
	@echo ..............................
	IF "%puerto%"=="" @echo ERROR - INGRESA PRIMERO EL PUERTO COM && timeout /t 5 && goto op1
	python arezZ3D.py %puerto% G28
	@echo ..............................
	pause
	goto:inicio
:op4
	cls
	@echo ..............................
	@echo Nivelar cama BLTOUCH
	@echo ..............................
	IF "%puerto%"=="" @echo ERROR - INGRESA PRIMERO EL PUERTO COM && timeout /t 5 && goto op1
	python arezZ3D.py %puerto% G29
	@echo ..............................
	pause
	goto:inicio
:op5
	cls
	@echo ..............................
	@echo Visualizar configuracion de impresora
	@echo ..............................
	IF "%puerto%"=="" @echo ERROR - INGRESA PRIMERO EL PUERTO COM && timeout /t 5 && goto op1
	python arezZ3D.py %puerto% M503
	@echo ..............................
	pause
	goto:inicio
:op6
	cls
	@echo .....................................
	@echo Calibrar Extrusor
	@echo ..............................
	IF "%puerto%"=="" @echo ERROR - INGRESA PRIMERO EL PUERTO COM && timeout /t 5 && goto op1
	@echo Selecciona una opcion:
	@echo Calibrar AUTO=1 - Calibrar MANUAL=2 
	@echo .....................................
	SET /p formacalibrar= ^> Ingresa [1-2]:
	if "%formacalibrar%"=="1" goto calibrar1
	if "%formacalibrar%"=="2" goto calibrar2
:op7
	cls
	@echo ..............................
	@echo Calibrar PID (Hotend)
	@echo ..............................
	IF "%puerto%"=="" @echo ERROR - INGRESA PRIMERO EL PUERTO COM && timeout /t 5 && goto op1
	@echo --------------------------------------------------------------------------
	@echo Es recomendable hacer autotune en los siguientes casos:
	@echo - La impresora es nueva
	@echo - La impresora se ha movido a un lugar con diferente temperatura
	@echo - La impresora no es capaz de alcanzar la temperatura objetivo y da error.
	@echo --------------------------------------------------------------------------
	@echo NOTA: RECUERDA QUE EL TEFLON DE SERIE NO SOPORTA ARRIBA DE 250 grados
	@echo ya que este se degrada rapido con altas temperaturas...
	@echo ______________________________________
	@echo RECOMENDACIONES SEGUN EL FILAMENTO:
	@echo [ABS]      210-260 grados
	@echo [PLA]      190-230 grados
	@echo [PETG]     220-250 grados
	@echo [NYLON]    240-270 grados
	@echo [HIPS]     220-260 grados
	@echo [PVA]  	   190-220 grados
	@echo [LAYWOOD]  170-250 grados
	@echo ______________________________________
	@echo Recomendado 210 [PLA-ABS]
	@echo ------------------------------------------------
	SET /p tempacalibrar= ^> Ingresa la temperatura a calibrar:
	@echo ------------------------------------------------
	::MANDAMOS LA TEMPERATURA
	python arezZ3D.py %puerto% M303E0C8S%tempacalibrar%
	@echo ************************************
	SET /p valorP= ^> Ingresa el valor P:
	SET /p valorI= ^> Ingresa el valor I:
	SET /p valorD= ^> Ingresa el valor D:
	@echo *********************************************************************
	@echo Los valores que se enviaran son: P:%valorP% I:%valorI% D:%valorD%
	@echo *********************************************************************
	@echo Guardar datos en el EPROOM? (1)SI (2)NO
	SET /p enviarpid= ^> Ingresa [1-2]:
	IF "%enviarpid%"=="1" (
		python arezZ3D.py %puerto% M301P%valorP%I%valorI%D%valorD%
		python arezZ3D.py %puerto% M500
		REM @echo PID HOTEND MANDADO
	) ELSE (
		timeout /t 2 && goto inicio
	)
	@echo .........................................
	@echo PID(HOTEND) ACTUALIZADO SATISFACTORIAMENTE
	@echo .........................................
	@echo ..............................
	pause
	goto:inicio
:op8
	cls
	@echo ..............................
	@echo Calibrar PID (Cama)
	@echo ..............................
	IF "%puerto%"=="" @echo ERROR - INGRESA PRIMERO EL PUERTO COM && timeout /t 5 && goto op1
	@echo --------------------------------------------------------------------------
	@echo Es recomendable hacer autotune en los siguientes casos:
	@echo - La impresora es nueva
	@echo - La impresora se ha movido a un lugar con diferente temperatura
	@echo - La impresora no es capaz de alcanzar la temperatura objetivo y da error.
	@echo --------------------------------------------------------------------------
	@echo ______________________________________
	@echo RECOMENDACIONES SEGUN EL FILAMENTO:
	@echo [ABS]      80-110 grados
	@echo [PLA]      30-60 grados
	@echo [PETG]     60-90 grados
	@echo [NYLON]    70-80 grados
	@echo [HIPS]     50-80 grados
	@echo [PVA]  	 50-60 grados
	@echo [LAYWOOD]  [[No es necesaria]]
	@echo ______________________________________
	@echo Recomendado 60 [PLA]
	@echo ------------------------------------------------
	SET /p tempcama= ^> Ingresa la temperatura a calibrar:
	@echo ------------------------------------------------
	::MANDAMOS LA TEMPERATURA
	python arezZ3D.py %puerto% M303E-1C4S%tempcama%
	@echo ************************************
	SET /p valorcamP= ^> Ingresa el valor P:
	SET /p valorcamI= ^> Ingresa el valor I:
	SET /p valorcamD= ^> Ingresa el valor D:
	@echo *********************************************************************
	@echo Los valores que se enviaran son: P:%valorcamP% I:%valorcamI% D:%valorcamD%
	@echo *********************************************************************
	@echo Guardar datos en el EPROOM? (1)SI (2)NO
	SET /p enviar22= ^> Ingresa [1-2]:
	IF %enviar22%==1 (
		python arezZ3D.py %puerto% M304P%valorP%I%valorI%D%valorD%
		python arezZ3D.py %puerto% M500
		REM @echo PID CAMA MANDADO
	) ELSE (
		timeout /t 2 && goto inicio
	)
	@echo .........................................
	@echo PID(CAMA) ACTUALIZADO SATISFACTORIAMENTE
	@echo .........................................
	@echo ..............................
	pause
	goto:inicio
:op9
	cls
	@echo ..............................
	@echo Deshabilitar motores
	@echo ..............................
	IF "%puerto%"=="" @echo ERROR - INGRESA PRIMERO EL PUERTO COM && timeout /t 5 && goto op1
	python arezZ3D.py %puerto% M18
	@echo ..............................
	pause
	goto:inicio
:op10
	cls
	@echo ..............................
	@echo Encender Leds
	@echo ..............................
	IF "%puerto%"=="" @echo ERROR - INGRESA PRIMERO EL PUERTO COM && timeout /t 5 && goto op1
	@echo ----------------------------------------------------
	@echo Elige el color a prender en el Led del extrusor...
	@echo 1=rojo 
	@echo 2=verde 
	@echo 3=azul 
	@echo 4=blanco
	@echo ----------------------------------------------------
	SET /p colorenviar= ^> Ingresa [1-4]:
	IF "%colorenviar%"=="1" (
	@echo Enviando color rojo
	python arezZ3D.py %puerto% M150R255
	)
	IF "%colorenviar%"=="2" (
	@echo Enviando color verde
	python arezZ3D.py %puerto% M150U255
	)
	IF "%colorenviar%"=="3" (
	@echo Enviando color azul
	python arezZ3D.py %puerto% M150B255
	)
	IF "%colorenviar%"=="4" (
	@echo Enviando color blanco
	python arezZ3D.py %puerto% M150R255U255B255
	)
	@echo ..............................
	pause
	goto:inicio
:op11
	cls
	@echo ..............................
	@echo Resetear EEPROM
	@echo ..............................
	IF "%puerto%"=="" @echo ERROR - INGRESA PRIMERO EL PUERTO COM && timeout /t 5 && goto op1
	@echo -------------------------------------------------------------------------
	@echo Resetear la EEPROM hara que tus valores de que hayas calibrado, queden en valores
	@echo predeterminados a como estan configurados en tu marlin/firmware...
	@echo -------------------------------------------------------------------------
	@echo 1=Resetear, 2=Salir
	SET /p reseteeprom= ^> Ingresa [1-2]: 
	IF "%reseteeprom%"=="1" (
	python arezZ3D.py %puerto% M502
	python arezZ3D.py %puerto% M500
	python arezZ3D.py %puerto% M501
	) ELSE (
	goto inicio
	)
	@echo ..............................
	@echo EEPROM Reseteada
	@echo ..............................
	pause
	goto:inicio
:op12
	cls
	@echo ..............................
	@echo Guardar EEPROM
	@echo ..............................
	IF "%puerto%"=="" @echo ERROR - INGRESA PRIMERO EL PUERTO COM && timeout /t 5 && goto op1
	@echo -------------------------------------------------------------------------
	@echo Guardar en EEPROM te sirve si haz calibrado valores de PID, pasos, etc
	@echo y ahora deseas usar esos valores de ahora en adelante..
	@echo -------------------------------------------------------------------------
	@echo 1=Guardar, 2=Salir:
	SET /p guardareprom= ^> Ingresa [1-2]: 
	IF "%guardareprom%"=="1" (
	python arezZ3D.py %puerto% M500
	) ELSE (
	goto inicio
	)
	@echo ..............................
	@echo EEPROM Guardada
	@echo ..............................
	pause
	goto:inicio
:op13
	cls
	@echo ..............................
	@echo Resetear BL-Touch
	@echo ..............................
	@echo Reseteando BLTouch en caso de errores...
	IF "%puerto%"=="" @echo ERROR - INGRESA PRIMERO EL PUERTO COM && timeout /t 5 && goto op1
	python arezZ3D.py %puerto% M280P0S60
	python arezZ3D.py %puerto% G4P500
	python arezZ3D.py %puerto% M280P0S90
	python arezZ3D.py %puerto% G4P200
	@echo ..............................
	@echo BL-Touch Reseteado...
	@echo ..............................
	pause
	goto:inicio
:op14
	cls
	@echo ..............................
	@echo Precalentar Impresora
	@echo ..............................
	IF "%puerto%"=="" @echo ERROR - INGRESA PRIMERO EL PUERTO COM && timeout /t 5 && goto op1
	@echo --------------------------------
	@echo Valores recomendados para PLA:
	@echo Temperatura Hotend: 200
	@echo Temperatura Cama: 60
	@echo --------------------------------
	SET /p prehotend= ^> Ingresa la temperatura de precalentado del hotend:
	SET /p precama= ^> Ingresa la temperatura de precalentado de la cama:
	@echo *********************************************************************
	@echo Los valores que se enviaran son: Hotend:%prehotend% Cama:%precama%
	@echo *********************************************************************
	@echo Deseas enviar estos valores? 1=si 2=salir
	SET /p enviartemps= ^> Ingresa [1-2]:
	IF "%enviartemps%"=="1" (
	rem hotend temp
	python arezZ3D.py %puerto% M104S%prehotend%E0
	rem cama temp
	python arezZ3D.py %puerto% M140S%precama%
	) ELSE (
	goto inicio
	)
	@echo ..............................
	@echo Precalentando...
	@echo ..............................
	pause
	goto:inicio
:op15
	cls
	@echo ..............................
	@echo Mandar GCODE personalizado
	@echo ..............................
	@echo NOTA: escribe tu gcode en MAYUSCULAS y una sola palabra
	@echo EJEMPLO: M92E488
	IF "%puerto%"=="" @echo ERROR - INGRESA PRIMERO EL PUERTO COM && timeout /t 5 && goto op1
	SET /p gcode= ^> Escribe el gcode:
	python arezZ3D.py %puerto% %gcode%
	@echo ..............................
	pause
	goto:inicio
:op16
	cls
	@echo ..............................
	@echo Cambiar Firmware
	@echo ..............................
	IF "%puerto%"=="" @echo ERROR - INGRESA PRIMERO EL PUERTO COM && timeout /t 5 && goto op1
	@echo ..................................................................................................
	@echo PRECAUCION: Este software solo te ayuda a subir el archivo.hex a tu impresora,
	@echo arezZ no se hace responsable por un mal uso.
	@echo RECUERDA tocar el firmware de tu impresora sin saber lo que haces, puede causarte problemas...
	@echo ..................................................................................................
	@echo NOTA: Por favor pon el hex en la ruta actual donde se encuentra el archivo arezZ3DMenu.exe
	@echo ..................................................................................................
	
	FOR %%F IN (*.hex) DO (
	SET variablehex=%%F
	)
	IF NOT EXIST *.hex ( @echo ERROR: No hay ningun Firmware en la ruta actual, metelo y reintanta de nuevo && timeout /t 3 && goto inicio ) ELSE ( @echo *************************************************************** && @echo El FIRMWARE ENCONTRADO Y QUE SE SUBIRA ES: %variablehex% && @echo *************************************************************** )
	@echo ........................................
	@echo Estas seguro de subir el firmware?
	@echo Selecciona 1=Subir Firmware 2=Cancelar
	@echo ........................................
	SET /p subirf=Digita tu respuesta:
	@echo ........................................
	IF %subirf%==1 ( @echo Subiendo Firmware... && goto actualizar3D ) ELSE ( @echo Cancelando... && @echo Regresando al inicio && timeout /t 3 && goto inicio )
	@echo *******************************************
	@echo Listo en teoria ya se subio tu firmware...
	@echo *******************************************
	pause
	goto:inicio
:op17
	cls
	@echo .......................
	@echo ......ADIOS MAKER......
	@echo ..NO OLVIDES APOYARME..
	@echo .......................
	timeout /t 3
	start https://www.youtube.com/c/arezZ-Tutoriales
	@cls&exit
	
	
	
	
	
::----------------------------CALIBRACION------------------------------
:calibrar1
	cls
	@echo ..............................
	@echo Calibracion automatica
	@echo ..............................
	@echo La calibracion automatica esta configurada entorno a 100 milimetros
	@echo .......................................................................
	SET defecto=100
	SET /p nuevos_pasos_automatico= ^> Ingresa los pasos que estan configurados por defecto en tu EPROOM:
	SET /p pasos_que_hace= ^> Ingresa los pasos que esta haciendo actualmente:
	set /a multi = %defecto% * %nuevos_pasos_automatico%
	set /a resultado = %multi% / %pasos_que_hace%
	@echo .......................................................................
	@echo Los pasos que deberia estar haciendo tu impresora son: %resultado%
	@echo .......................................................................
	@echo Elige (1) si quieres configurar los pasos calulados - (2)Regresar al inicio
	SET /p enviar= ^> Ingresa [1-2]
	IF "%enviar%"=="1" (
		python arezZ3D.py %puerto% M92E%resultado%
		python arezZ3D.py %puerto% M500
		@echo .......................................................................
		@echo Mandando nuevos pasos a la impresora
		@echo .......................................................................
		@echo LISTO, AHORA PUEDES VER TUS NUEVOS DATOS CONFIGURADOS
		python arezZ3D.py %puerto% M503
		@echo .......................................................................
	) ELSE (
		goto inicio
	)
	pause
	goto:inicio
:calibrar2
	cls
	@echo ..............................
	@echo Calibracion manual
	@echo ..............................
	SET /p nuevos_pasos_manual= ^> Dame los nuevos pasos que mediste:
	python arezZ3D.py %puerto% M92E%nuevos_pasos_manual%
	python arezZ3D.py %puerto% M500
	@echo .......................................................................
	@echo LISTO, AHORA PUEDES VER TUS NUEVOS DATOS CONFIGURADOS
	python arezZ3D.py %puerto% M503
	@echo .......................................................................
	pause
	goto:inicio
::---------------------------------------------------------------------

::---------------------------------------------------------------------
:actualizar3D
	rem @echo SI ACTUALIZAREMOS
	cd files
	avrdude -p m2560 -c stk500v2 -P %puerto% -b 115200 -F -U flash:w:../%variablehex%
	cd..
	@echo *******************************************
	@echo Listo, en teoria ya se subio el firmware...
	@echo *******************************************
	pause
	goto:inicio
::---------------------------------------------------------------------

pause