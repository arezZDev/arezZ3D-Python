#!/usr/bin/env python
# -*- coding: utf-8 -*-

import serial , time
import serial.tools.list_ports
import sys
from serial import SerialException


####################################
global serialImpresora3D, puerto_global
serialImpresora3D = serial.Serial()


def Bienvenida():
    print ("*****************************************************************************")
    print ("Software Iniciado correctamente")
    print ("Este software te ayudara a mandar codigos GCODE más rapido a tu impresora")
    print ("Este software esta configurado para impresoras ARTILLERY")
    print ("Creador: arezZ (Hector Lml)")
    print ("*****************************************************************************")
    print ("Para usarlo en consola:")
    print ("Sintaxis: arezZ3D.exe (PUERTO) (GCODE)")
    print ("Ejemplo: arezZ3D.exe COM4 G28")
    #print ("Sintaxis: python arezZ3D.py (PUERTO) (GCODE)")
    #print ("Ejemplo: python arezZ3D.py COM4 G28")
    print ("*****************************************************************************")



def all():
    #Para conexion CMD
    #print("argumentos", sys.argv)
    puerto_impresoraCMD = sys.argv[1]#variable CMD del puerto
    codigoCMD = sys.argv[2]#variable CMD del puerto
    #puerto_impresoraCMD = "COM4"
    #codigoCMD = "M503"
    try:
        if puerto_impresoraCMD == "null" and codigoCMD == "PUERTOS":
            ports = serial.tools.list_ports.comports(include_links=False)
            for port in ports:
                print("***********************")
                print("PUERTOS DISPONIBLES")
                print("***********************")
                print("--------------------------")
                print("-> "+port.device)
                print("--------------------------")
        else:
            serialImpresora3D = serial.Serial(puerto_impresoraCMD,250000,timeout=1)
            if(serialImpresora3D.isOpen()):
                serialImpresora3D.close()
                print("Puerto abierto | Conectandose...")
                time.sleep(1)   #Espera 1 segundos
                #Conectamos la impresora con el software
                serialImpresora3D = serial.Serial(puerto_impresoraCMD,250000)
                time.sleep(2)   #Espera 2 segundos para conectar puerto serial
                print("Conectado al puerto satisfactoriamente")
                #########################################################################
            if codigoCMD == "M503":
                #print("codigo m503 ingresado")
                print("------------------------------------------------")
                serialImpresora3D.write(str.encode(codigoCMD+"\r\n")) #envia el gcode correctamente
                time.sleep(1)
                print("------------------------------------")
                print("CONFIGURACION DE TU IMPRESORA:")
                print("------------------------------------")
                for x in range(26):
                    datos = serialImpresora3D.readline()
                    datos_string = str(datos)
                    if "b'echo:" in datos_string:
                        txt1formatedo = datos_string.replace("b'echo:","") 
                        txt2formatedo = txt1formatedo.replace("\\n'","")#escapamos el slash invertido con otro slash invertido
                        print("*->   "+txt2formatedo)
                serialImpresora3D.flush()
                print("------------------------------------------------")
            if codigoCMD == "M500":
                print("------------------------------------------------")
                serialImpresora3D.write(str.encode(codigoCMD+"\r\n")) #envia el gcode correctamente
                time.sleep(1)
                seguir0 = 1
                while seguir0 != 0:#otra forma de terminar el bucle por si tengo que meterlo de nuevo
                    datos = serialImpresora3D.readline()
                    datos_string = str(datos)
                    if "Settings Stored" in datos_string:
                        print("M500 SOPORTADO | GUARDANDO...")
                        seguir0 = 0
                    else:
                        print("TU FIRMWARE NO SOPORTA GUARDAR EN EEPROM")#tal vez genere error esto, ya veremos 7u7
                        print("LOS DATOS QUE TRATASTDE DE GUARDAR NO SE GUARDARAN")
                        print("HABILITA EL M500 EN TU FIRMWARE...")
                        seguir0 = 0
                serialImpresora3D.flush()

            if codigoCMD == "M115":
                #print("codigo m115 ingresado")
                print("------------------------------------------------")
                serialImpresora3D.write(str.encode(codigoCMD+"\r\n")) #envia el gcode correctamente
                time.sleep(1)
                print("------------------------------------")
                print("INFORMACION DE FIRMWARE:")
                print("------------------------------------")
                seguir = 1
                while seguir != 0:#otra forma de terminar el bucle por si tengo que meterlo de nuevo
                    datos = serialImpresora3D.readline()
                    datos_string = str(datos)
                    txt1formatedo = datos_string.replace("b'","")
                    txt2formatedo = txt1formatedo.replace("\\n'","")
                    print("*->"+txt2formatedo)
                    if "b'Cap:" in datos_string:
                        txt1formatedo = datos_string.replace("b'Cap:","")
                        txt2formatedo = txt1formatedo.replace("\\n'","")#escapamos el slash invertido con otro slash invertido
                        print("*->"+txt2formatedo)
                    if "ok" in datos_string:
                        seguir = 0
                '''for x in range(17):#calar 18 por el ok
                    datos = serialImpresora3D.readline()
                    datos_string = str(datos)
                    if x == 0: #Primera linea arreglada
                        txt1formatedo = datos_string.replace("b'","")
                        txt2formatedo = txt1formatedo.replace("\\n'","")
                        print("*->"+txt2formatedo)
                    if "b'Cap:" in datos_string:
                        txt1formatedo = datos_string.replace("b'Cap:","")
                        txt2formatedo = txt1formatedo.replace("\\n'","")#escapamos el slash invertido con otro slash invertido
                        print("*->"+txt2formatedo)'''
                serialImpresora3D.flush()
                print("------------------------------------------------")
            if "M303E0C8S" in codigoCMD:#DETECTAMOS QUE ES CALIBRACION DE PID HOTEND
                #print("CODIGO PID INGRESADO | SE DETECTO: M303E0C8S")
                #print("EL CODIGO COMPLETO ES: "+codigoCMD)
                print("------------------------------------")
                print("INICIANDO CALIBRACION PID HOTEND:")
                print("------------------------------------")
                print("------------------------------------------------")
                #ENCENDEMOS VENTILADORES
                serialImpresora3D.write(str.encode("M106F255"+"\r\n")) #envia el gcode correctamente
                time.sleep(1)
                serialImpresora3D.write(str.encode(codigoCMD+"\r\n")) #envia el gcode correctamente
                time.sleep(1)
                print("------------------------------------")
                seguir = 1
                while seguir != 0:#otra forma de terminar el bucle por si tengo que meterlo de nuevo
                    datos = serialImpresora3D.readline()
                    datos_string = str(datos)
                    txt1formatedo = datos_string.replace("b'","")
                    txt2formatedo = txt1formatedo.replace("\\n'","")
                    print("*-> "+txt2formatedo)
                    if "#define DEFAULT_Kd" in datos_string:
                        seguir = 0
                #APAGAMOS VENTILADORES
                serialImpresora3D.write(str.encode("M107"+"\r\n")) #envia el gcode correctamente
                time.sleep(1)
                serialImpresora3D.flush()
            if "M303E-1C4S" in codigoCMD:#DETECTAMOS QUE ES CALIBRACION DE PID CAMA
                print("------------------------------------")
                print("INICIANDO CALIBRACION PID DE CAMA:")
                serialImpresora3D.write(str.encode(codigoCMD+"\r\n")) #envia el gcode correctamente
                time.sleep(1)
                print("------------------------------------")
                seguir = 1
                while seguir != 0:#otra forma de terminar el bucle por si tengo que meterlo de nuevo
                    datos = serialImpresora3D.readline()
                    datos_string = str(datos)
                    txt1formatedo = datos_string.replace("b'","")
                    txt2formatedo = txt1formatedo.replace("\\n'","")
                    print("*-> "+txt2formatedo)
                    if "#define DEFAULT_bedKd" in datos_string:
                        seguir = 0
                serialImpresora3D.flush()
            else: #CUALQUIERA QUE NO ENVIA CODIGO ESPECIAL DE OBTENCION DE DATOS
                serialImpresora3D.write(str.encode(codigoCMD+"\r\n")) #envia el gcode correctamente
                time.sleep(1)


    except SerialException:
        print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
        print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
        print("(ERROR) Desconecta la impresora de otros softwares o laminadores que esten usando el puerto: "+puerto_impresoraCMD)
        print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
        print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")



if __name__ == "__main__":
    #print("HOLA ESTE SE DEBERIA INICIAR PRIMERO")
    Bienvenida()
    all()
    
