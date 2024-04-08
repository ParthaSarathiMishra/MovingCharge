video = VideoWriter("D:\plot.avi", 'Uncompressed AVI');
video.FrameRate = 24;

open(video);

global prev_x
global prev_y
global RES
global RES2
global vel

RES = 1000;
RES2 = 50;

figure('units','pixels','position',[0 0 1000 1000]);

t = 0.0;
vel = 0.0;

for vel=0.0:0.01:0.9
    clf;
    prev_x = linspace(vel*t,vel*t,RES2);
    prev_y = linspace(0,0,RES2);
    draw_pot(10,t);
    pause(0.1);
    t = t + 0.1;
    frame = getframe(gcf);
    writeVideo(video, frame);
end

close(video);

function draw_pot(Q,t)
hold on;
c = 1;
global RES
global RES2
global prev_x
global prev_y
global vel

grayColor = [.7 .7 .7];

x = linspace(-20,20,RES);

pot1 = 3.0;
pot2 = 0.1;
pot_delta = -0.1;

for p=pot1:pot_delta:pot2
    b = 1/sqrt(1-vel^2/c^2);
    y=sqrt((Q^2)/((b^2)*(p^2))-(b^2)*((x-vel*t).^2));

    vel = vel - 0.02;

    plot(x,y,'Color',grayColor);
    plot(x,-y,'Color',grayColor);
    
    len = 0;

    for i=1:1:RES
        if(y(i) > 0.01)
            len = len + 1;
        end
    end

    x2 = linspace(0,0,len+2);
    y2 = linspace(0,0,len+2);

    j = 2;

    for i=1:1:RES
        if(y(i) > 0.01)
            x2(j) = x(i);
            y2(j) = y(i);
            if(j == 2)
                x2(j - 1) = x(i);
                y2(j - 1) = 0;
            end            
            j = j + 1;
        end
        if(j == len + 1)
            x2(len+2) = x(i+1);
        end
    end

    x2(len+2) = 0;
    y2(len+2) = 0;

    x3 = linspace(0,0,RES2);
    y3 = linspace(0,0,RES2);

    f = (len + 2)/RES2;

    for i=1:1:RES2-1
        index = int32(1 + (i-1)*f);
        x3(i) = x2(index);
        y3(i) = y2(index);
    end

    y3(RES2) = 0;

    for i=1:1:RES2
        plot([prev_x(i), x3(i)], [prev_y(i), y3(i)], 'Color','b');
        plot([prev_x(i), x3(i)], [-prev_y(i), -y3(i)], 'Color','b');
        prev_x(i) = x3(i);
        prev_y(i) = y3(i);
    end
    
    xlim([-20 20]);
    ylim([-20 20]);
end
hold off;
end
