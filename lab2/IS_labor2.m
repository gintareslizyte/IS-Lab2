%% apmokymo koef.
n = 0.2;
index=0;
z=500000; %% number of cycles to generate

%% svoriai su randn priskirti paslėptajam sluoksniui
%% svoriai su randn priskirti antrajam sluoksniui
global w11 w12 w13 w14 w15 b11 b12 b13 b14 b15 b21 w21 w22 w23 w24 w25
%% užpildom svorius su randn vertem kvieciam init f-ja
init()


%% vienas įėjimas (įėjime paduodamas 20 skaičių vektorius X, 
%% su reikšmėmis intervale nuo 0 iki 1
%% https://github.com/serackis/IS-Lab2
xx = [0.01:1/20:1];
yy = (1 + 0.6*sin(2*pi*xx/0.7) + 0.3*sin(2*pi*xx))/2;

plot (xx,yy, 'r*'); 
grid on;

while index < z
    index = index+ 1;
    for i=1:length(xx)
        %% Tinklo atsakas pirmajam neuronui
        v11 = xx(i)*w11 + b11;
        v21 = xx(i)*w12 + b12;
        v31 = xx(i)*w13 + b13;
        v41 = xx(i)*w14 + b14;
        v51 = xx(i)*w15 + b15;
        
        %% taikome tiesine aktyvavimo funkcija išėjimo neurone
        y11 = calcy(v11);
        y21 = calcy(v21);
        y31 = calcy(v31);
        y41 = calcy(v41);
        y51 = calcy(v51);
        
        %% Tinklo atsakas antrajam neuronui
        v12 = y11*w21+y21*w22+y31*w23+y41*w24+y51*w25 + b21;
        %% tiesine aktyvavimo funkcija antro išėjimo neurone 
        y12 = tanh(v12);
        %% calculate the total error
        e = yy(i) - y12;
        
        %% Ryšių svorių atnaujinimas
        %% skaičiuojame klaidos gradientą išėjimo sluoksnio neuronui
        d12 = (1-(tanh(v12))^2)*e;
        %% skaičiuojame klaidos gradientą paslėptojo sluoksnio neuronams
        d11 = y11*(1-y11)*d12*w21;
        d21 = y21*(1-y21)*d12*w22;
        d31 = y31*(1-y31)*d12*w23;
        d41 = y41*(1-y41)*d12*w24;
        d51 = y51*(1-y51)*d12*w25;
        %% atnaujiname išėjimo sluoksnio svorius
        w21 = w21 + n*d12*y11;
        w22 = w22 + n*d12*y21;
        w23 = w23 + n*d12*y31;
        w24 = w24 + n*d12*y41;
        w25 = w25 + n*d12*y51;
        b21 = b21 + n*d12;
        %% atnaujiname paslėptojo sluoksnio svorius
        w11 = w11 + n*d11*xx(i);
        w12 = w12 + n*d21*xx(i);
        w13 = w13 + n*d31*xx(i);
        w14 = w14 + n*d41*xx(i);
        w15 = w15 + n*d51*xx(i);
        %% atnaujiname vertes
        b11 = b11 + n*d11;
        b12 = b12 + n*d21;
        b13 = b13 + n*d31;
        b14 = b14 + n*d41;
        b15 = b15 + n*d51;
    end
end

xx = [0.01:1/300:1];

for i=1:length(xx)
        %% Skaičiuojame tinklo atsaką
        %% pirmojo sluoksnio neuronams
        %% su aktyvavimo f-jos pritaikymu
        
        y11 = calcy(xx(i)*w11 + b11);
        y21 = calcy(xx(i)*w12 + b12);
        y31 = calcy(xx(i)*w13 + b13);
        y41 = calcy(xx(i)*w14 + b14);
        y51 = calcy(xx(i)*w15 + b15);
        
        %% Antrojo sluoksnio neurono tinklo atsakas su hiperbolinio tangento akt. f-ja
        v12 = tanh(y11*w21+y21*w22+y31*w23+y41*w24+y51*w25 + b21);
        Y(i) = v12;
end

hold on;
plot (xx, Y, 'b+'); 
hold off;


function init()
    global w11 w12 w13 w14 w15 b11 b12 b13 b14 b15 b21 w21 w22 w23 w24 w25
    w11 = randn(1);
    w12 = randn(1);
    w13 = randn(1);
    w14 = randn(1);
    w15 = randn(1);
    b11 = randn(1);
    b12 = randn(1);
    b13 = randn(1);
    b14 = randn(1);
    b15 = randn(1);

    w21 = randn(1);
    w22 = randn(1);
    w23 = randn(1);
    w24 = randn(1);
    w25 = randn(1);
    b21 = randn(1);
end


function vv = calcy(x)
	vv = 1/(1+exp(-x));
end

