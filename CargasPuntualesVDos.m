function CargasPuntualesVDos()

    % Hecho por:
    % David Josué Marcial Quero 
    % Diego Solis Higuera 
    % Carlos Augusto Pluma Seda 

    close all; 
    clc; % Se limpia la ventana de comandos y se cierran cualquier otro figure que se tenía previamente
    
    [nPuntos, minX, maxX, minY, maxY, radioC, xCargas, yCargas, k, cargasFinales, eleccionPosicion, cantidadCargas] = variablesIniciales(); % Función que sirve para obtener los valores iniciales según los
    %inputs del usuario.
    
    [campoElectricoX, campoElectricoY, xPuntosMalla,yPuntosMalla] = ...
    puntosCampoElectrico(nPuntos, minX, maxX, minY, maxY); % Función que sirve para crear los puntos que representaran al campo eléctrico
    
    [campoElectricoX, campoElectricoY, magnitudCampoETotal] = obtenerCampoElectrico...
    (xPuntosMalla, yPuntosMalla, xCargas, yCargas, k, campoElectricoX,campoElectricoY, cargasFinales, eleccionPosicion, cantidadCargas); %Función que sirve para calcular los valores del campo eléctrico
    
    graficaCampoElectrico(xPuntosMalla, yPuntosMalla, campoElectricoX,campoElectricoY, magnitudCampoETotal, radioC, xCargas, yCargas, cargasFinales, minX, maxX, minY, maxY, cantidadCargas, eleccionPosicion); % Función que sirve
    %para graficar el campo eléctrico y el dipolo eléctrico.
end

function [nPuntos, minX, maxX, minY, maxY, radioC, xCargas, yCargas, k, cargasFinales, eleccionPosicion, cantidadCargas] = variablesIniciales()
    nPuntos = 50; % Puntos para representar el campo eléctrico
    
    fprintf("Al ser dos grupos de cargas puntuales (misma magnitud de carga eléctrica pero de signo opuesto), solo es necesario ingresar un numero \n")
    carga = input("Ingrese la magnitud de las cargas (un numero positivo): ");
    cantidadCargas = input("Ingrese la cantida de cargas que desea que hayan en cada grupo: ");
    eleccionPosicion = input("Ingrese el número de la opción correspondiente de la representación de los grupos de cargas que desea: 1) Vertical 2) Horizontal: ");
    
    % El usuario ingresará la entre los dos grupos de cargas
    dis = (input("Ingrese la distnacia entre los 2 grupos de cargas: "))/2;
    
    disCargaPos = input("Ingrese la distnacia que habrá entre el grupo de cargas positivas: ");
    disCargaNeg = input("Ingrese la distnacia que habrá entre el grupo de cargas negativas: ");
    
    
    disPos1 = (disCargaPos*cantidadCargas)/-2;
    disPos2 = (disCargaPos*cantidadCargas)/2;
    disNeg1 = (disCargaNeg*cantidadCargas)/-2;
    disNeg2 = (disCargaNeg*cantidadCargas)/2;
    posicionCargasPos = linspace(disPos1,disPos2,cantidadCargas);
    posicionCargasNeg = linspace(disNeg1,disNeg2,cantidadCargas);
    
    if eleccionPosicion == 1
        posicion = input("¿En qué posición desea que estén las cargas positivas? (Ingrese el número de la opción correspondiente) 1) Izquierda 2) Derecha: ");
        yCargas = [posicionCargasPos;posicionCargasNeg];% Valor de las posiciones de las cargas en Y
        xCargas = [-dis,dis];% Valor de las posiciones de las cargas en X
        if posicion == 1
            cargasFinales = [carga, -carga]; % Son dos cargas de diferente signo
        elseif posicion == 2
            cargasFinales = [-carga, carga]; % Son dos cargas de diferente signo
        end
    elseif eleccionPosicion == 2
        posicion = input("¿En qué posición desea que estén las cargas positivas? (Ingrese el número de la opción correspondiente) 1) Abajo 2) Arriba: ");
        xCargas = [posicionCargasPos;posicionCargasNeg];
        yCargas = [-dis,dis];
        if posicion == 1
            cargasFinales = [carga, -carga]; % Son dos cargas de diferente signo
        elseif posicion == 2
            cargasFinales = [-carga, carga]; % Son dos cargas de diferente signo
        end
    end
   
    % Determinar la distancia más grande entre las cargas para establecer los límites del campo eléctrico
    
    if dis >= disPos2 && dis >= disNeg2
        distancia = dis;
        if disPos2 > disNeg2
            rango = disNeg2;
        else
            rango = disPos2;
        end
    elseif disPos2 >= dis && disPos2 >= disNeg2
        distancia = disPos2;
        if dis > disNeg2
            rango = disNeg2;
        else
            rango = dis;
        end
    elseif disNeg2 >= dis && disNeg2 >= disPos2
        distancia = disPos2;
        if dis > disPos2
            rango = disPos2;
        else
            rango = dis;
        end
    end
    
    radioC = ((rango*2) / (cantidadCargas))/2; % Radio de la carga
    
    maxX = distancia + (radioC * 6);
    minX = -distancia - (radioC * 6); % Límites del campo eléctrico en X
    maxY = distancia + (radioC * 6);
    minY = -distancia - (radioC * 6); % Límites del campo eléctrico en Y
    
    eps = 8.854e-12; % Cálculo del valor de la constante eléctrica en el vacío
    k = 1/(4*pi*eps);
end

function [campoElectricoX, campoElectricoY, xPuntosMalla,yPuntosMalla] = ...
    puntosCampoElectrico(nPuntos, minX, maxX, minY, maxY)

    % Definir espacio para guardar campo electrico en los componentes x y y
    campoElectricoX = zeros(nPuntos);
    campoElectricoY = zeros(nPuntos);

    % Creamos vectores para trabajar con el meshgrid
    X = linspace(minX,maxX,nPuntos);
    Y = linspace(minY,maxY,nPuntos);
    
    % Creamos la malla
    [xPuntosMalla,yPuntosMalla] = meshgrid(X,Y);
end

function [campoElectricoX, campoElectricoY, magnitudCampoETotal] = obtenerCampoElectrico...
    (xPuntosMalla, yPuntosMalla, xCargas, yCargas, k, campoElectricoX,...
    campoElectricoY, cargasFinales, eleccionPosicion, cantidadCargas)

    % Recorrido de las cargas para calcular campo electrico
    for renglon = 1:1:2
        if eleccionPosicion == 1
            distanciaX = xPuntosMalla - xCargas(renglon);
            for columna = 1:1:cantidadCargas
                distanciaY = yPuntosMalla - yCargas(renglon,columna);
                R = sqrt(distanciaX .^2 + distanciaY .^2); % Cálculo de la distancia
                R3 = R.^3;
                campoElectricoY = campoElectricoY + ((k .* cargasFinales(renglon) .* distanciaY) ./R3);
                campoElectricoX = campoElectricoX + ((k .* cargasFinales(renglon) .* distanciaX) ./R3);
            end
            
        elseif eleccionPosicion == 2
            distanciaY = yPuntosMalla - yCargas(renglon);
            for columna = 1:1:cantidadCargas
                distanciaX = xPuntosMalla - xCargas(renglon,columna);
                R = sqrt(distanciaX .^2 + distanciaY .^2); % Cálculo de la distancia
                R3 = R.^3;
                campoElectricoX = campoElectricoX + ((k .* cargasFinales(renglon) .* distanciaX) ./R3);
                campoElectricoY = campoElectricoY + ((k .* cargasFinales(renglon) .* distanciaY) ./R3);
            end
        end  
    end
    magnitudCampoETotal = sqrt(campoElectricoX .^2 + campoElectricoY .^2); % Se calcula la magnitud del campo magnético en base al vector.

end

function graficaCampoElectrico(xPuntosMalla, yPuntosMalla, campoElectricoX, campoElectricoY, magnitudCampoETotal, radioC, xCargas, yCargas, cargasFinales, minX, maxX, minY, maxY, cantidadCargas, eleccionPosicion)

    % Graficacion con quiver
    quiver(xPuntosMalla, yPuntosMalla, campoElectricoX ./ magnitudCampoETotal, campoElectricoY ./ magnitudCampoETotal)
    
    % Se divide para normalizar el tamaño
    hold on
    xlim([minX, maxX])
    ylim([minY, maxY])
    xlabel("X[m]");
    ylabel("Y[m]");
    axis square
    % Para pos_ xCargas(1) es el centro de la carga, y para dibujar la carga,
    % queremos la esquina inferior derecha, por eso se le resta radioC
    for i = 1:1:2
        if eleccionPosicion == 1
            pos_x = xCargas(i) - radioC;
            for columnas = 1:1:cantidadCargas
                pos_y = yCargas(i,columnas) - radioC;
                % Se multiplica por dos porque queremos el diametro del circulo
                if cargasFinales(i) < 0
                    rectangle('Position',[pos_x, pos_y, 2*radioC,  2*radioC],'Curvature',[1, 1],'FaceColor', 'r' ,'EdgeColor',[0 0 1])
                    text(xCargas(i), yCargas(i,columnas),'-','Color','white','FontSize',25)
                else
                    rectangle('Position',[pos_x, pos_y, 2*radioC,  2*radioC],'Curvature',[1, 1],'FaceColor', 'b' ,'EdgeColor',[0 0 1])
                    text(xCargas(i), yCargas(i,columnas),'+','Color','white','FontSize',25)
                end
            end
        elseif eleccionPosicion == 2
            pos_y = yCargas(i) - radioC;
            for columnas = 1:1:cantidadCargas
                pos_x = xCargas(i,columnas) - radioC;
                % Se multiplica por dos porque queremos el diametro del circulo
                if cargasFinales(i) < 0
                    rectangle('Position',[pos_x, pos_y, 2*radioC,  2*radioC],'Curvature',[1, 1],'FaceColor', 'r' ,'EdgeColor',[0 0 1])
                    text(xCargas(i,columnas), yCargas(i),'-','Color','white','FontSize',radioC)
                else
                    rectangle('Position',[pos_x, pos_y, 2*radioC,  2*radioC],'Curvature',[1, 1],'FaceColor', 'b' ,'EdgeColor',[0 0 1])
                    text(xCargas(i,columnas), yCargas(i),'+','Color','white','FontSize',radioC)
                end
            end
        end
    end
end
