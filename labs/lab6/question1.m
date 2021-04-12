robot = SchunkUTSv2_0();
q1 = [0,pi/2,0,0,0,0];
d1 = 1.9594;

q2 = [ pi/10, pi/2, 0, 0, 0, 0 ];
d2 =2.4861;

q3 = [ -pi/10, 5*pi/12, 0, 0, 0, 0 ];
d3 = 1.9132;

robot.plot3d(q1);
view(3);
camlight;
hold on;

% plot ray 1
tr = robot.fkine(q1)
startP = tr(1:3,4);
v1 = tr(1:3,4) + d1 * tr(1:3,3);
line1_h = plot3([startP(1),v1(1)],[startP(2),v1(2)],[startP(3),v1(3)],'r');
plot3(v1(1),v1(2),v1(3),'r*');

% plot ray 2
tr = robot.fkine(q2)
startP = tr(1:3,4);
v2 = tr(1:3,4) + d1 * tr(1:3,3);
line2_h = plot3([startP(1),v2(1)],[startP(2),v2(2)],[startP(3),v2(3)],'r');
plot3(v2(1),v2(2),v2(3),'r*');

%plot ray 3
tr = robot.fkine(q3)
startP = tr(1:3,4);
v3 = tr(1:3,4) + d1 * tr(1:3,3);
line3_h = plot3([startP(1),v3(1)],[startP(2),v3(2)],[startP(3),v3(3)],'r');
plot3(v3(1),v3(2),v3(3),'r*');

%determine surface normal
verts = [v1'; v2'; v3';];
triangleNormal = unit(cross((verts(1,:)-verts(2,:)),(verts(2,:)-verts(3,:))));

% Make a plane at the orgin, to rotate later
basePlaneNormal = [-1,0,0];
[Y,Z] = meshgrid(-2:0.1:2,-2:0.1:2  );
sizeMat = size(Y);
X = zeros(sizeMat(1),sizeMat(2));

% Rotation axis: to rotate the base plane around
rotationAxis = unit(cross(triangleNormal,basePlaneNormal));

% Rotation angle: how much to rotate base plane to make it match triangle plane
rotationRadians = acos(dot(triangleNormal,basePlaneNormal));
% Make a transform to do that rotation
tr = makehgtform('axisrotate',rotationAxis,rotationRadians);

% Find a central point of the triangle
trianglePoint = sum(verts)/3;

% Plot the point of triangle surface
plot3(trianglePoint(1),trianglePoint(2),trianglePoint(3),'g*');

%plot the normal vector
plot3([trianglePoint(1),trianglePoint(1)+triangleNormal(1)] ...     
    ,[trianglePoint(2),trianglePoint(2)+triangleNormal(2)] ...     
    ,[trianglePoint(3),trianglePoint(3)+triangleNormal(3)],'b');
drawnow();

% Transform the points on the default plane, to matches the actual triangle
points = [X(:),Y(:),Z(:)] * tr(1:3,1:3) + repmat(trianglePoint,prod(sizeMat),1);
X = reshape(points(:,1),sizeMat(1),sizeMat(2));
Y = reshape(points(:,2),sizeMat(1),sizeMat(2));
Z = reshape(points(:,3),sizeMat(1),sizeMat(2));
% Make points where Z<0 to be = zero
Z(Z<0)= 0;
surf(X,Y,Z);
pause(1);


laserRange = 3;
startQ = [0,pi/2,0,0,0,0];
startP = robot.fkine(startQ);
