t = tiledlayout(2,1);
ax1 = nexttile(1,[1,1]);
imshow('Lab1_CircularRaceTrack.jpg'); 
axis on;
centre_x = 313;
centre_y = 313;
rotation_speed = 0.01;
x = zeros(0);
y = zeros(0);

T_car_red = se2(300,550,0);
hold on
h_T_car_red = trplot2(T_car_red,'frame', 'car_red', 'color', 'r', 'length', 50);



T_car_blue = se2(300, 125, 0);
h_T_car_blue = trplot2(T_car_blue, 'frame', 'car_blue', 'color', 'b', 'length', 50);

T_rotation_red = se2(centre_x,centre_y)* se2(0,0,-rotation_speed)*se2(-centre_x,-centre_y,0);
T_rotation_blue = se2(centre_x,centre_y)* se2(0,0,rotation_speed)*se2(-centre_x,-centre_y,0);

message = sprintf('%0.2e  %0.2e  %0.2e\n%0.2e  %0.2e  %0.2e\n%0.2e  %0.2e  %0.2e',T_car_red(1,1),T_car_red(1,2),T_car_red(1,3),T_car_red(2,1),T_car_red(2,2),T_car_red(2,3),T_car_red(3,1),T_car_red(3,2),T_car_red(3,3));


i = 0;
while i < 1000
    nexttile(1,[1,1]);
    T_car_red = T_rotation_red*T_car_red;
    T_car_blue = T_rotation_blue*T_car_blue;
    
    delete(h_T_car_red);
    delete(h_T_car_blue);
    h_T_car_red = trplot2(T_car_red, 'frame', 'car_red', 'color', 'r', 'length', 50);
    h_T_car_blue = trplot2(T_car_blue, 'frame', 'car_blue', 'color', 'b', 'length', 50);

    message = sprintf('%0.2e  %0.2e  %0.2e\n%0.2e  %0.2e  %0.2e\n%0.2e  %0.2e  %0.2e',T_car_red(1,1),T_car_red(1,2),T_car_red(1,3),T_car_red(2,1),T_car_red(2,2),T_car_red(2,3),T_car_red(3,1),T_car_red(3,2),T_car_red(3,3));
    delete(tf_text);
    tf_text= text(10, 50, message, 'FontSize', 10, 'Color', [.6 .2 .6]);
    drawnow();
    pause(0.01);
    i= i+1;
    T_red_to_blue = inv(T_car_red) * T_car_blue;
    distance = sqrt(T_red_to_blue(1,3)^2 + T_red_to_blue(2,3)^2);
    x = [x, i*0.01];
    y = [y, distance];
    nexttile(2,[1,1]);
    plot(x,y)
end
