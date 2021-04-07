L1 = Link('d',0,'a',1,'alpha',0,'qlim',[-pi pi])
L2 = Link('d',0,'a',1,'alpha',0,'qlim',[-pi pi])
L3 = Link('d',0,'a',1,'alpha',0,'qlim',[-pi pi])
robot = SerialLink([L1 L2 L3],'name','myRobot');

robot.base = troty(pi);

q = zeros(1,3);
robot.plot(q,'workspace',[-2 2 -2 2 -0.05 2],'scale',0.5);
hold on
robot.teach;
newQ = q;
for i = -0.5:0.05:0.5
    newQ = robot.ikine(transl(-0.75,i,0),newQ,[1,1,0,0,0,0]);
    robot.plot(newQ)
    T = robot.fkine(newQ);
    plot3(T(1,3), T(2,3), 0, 'o');
%     robot.animate(newQ);
    drawnow();
end