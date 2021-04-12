L1 = Link('d', 0, 'a', 1, 'alpha', 0);
L2 = Link('d', 0, 'a', 1, 'alpha', 0);
L3 = Link('d', 0, 'a', 1, 'alpha', 0);

robot = SerialLink([L1, L2, L3]);

q = zeros(1,3);
scale = 0.5;
workspace = [-2 2 -2 2 -0.05 2];
% Set the size of the workspace when drawing the robot
robot.plot(q,'workspace',workspace,'scale',scale); 
hold on

% 2.2 and 2.3
centerpnt = [2,0,-0.5];
side = 1.5;
plotOptions.plotFaces = true;
[vertex,faces,faceNormals] = RectangularPrism(centerpnt-side/2, centerpnt+side/2,plotOptions);
axis equal
camlight
% pPoints = [1.25,0,-0.5 ...
%         ;2,0.75,-0.5 ...
%         ;2,-0.75,-0.5 ...
%         ;2.75,0,-0.5];
% pNormals = [-1,0,0 ...
%             ; 0,1,0 ...
%             ; 0,-1,0 ...
%             ;1,0,0];
robot.teach;
tr = GetRobotJointTransforms(robot,q);
% 2.6: Go through until there are no step sizes larger than 1 degree
q1 = [-pi/4,0,0];
q2 = [pi/4,0,0];
steps = 2;
while ~isempty(find(1 < abs(diff(rad2deg(jtraj(q1,q2,steps)))),1))
    steps = steps + 1;
end
qMatrix = jtraj(q1,q2,steps);

intersection = false(steps,1);
for q=1:1:size(qMatrix)
    tr = GetRobotJointTransforms(robot, qMatrix(q,:));
    for i = 1 : size(tr,3)-1        
        for faceIndex = 1:size(faces,1)
            vertOnPlane = vertex(faces(faceIndex,1)',:);
            [intersectP,check] = LinePlaneIntersection(faceNormals(faceIndex,:),vertOnPlane,tr(1:3,4,i)',tr(1:3,4,i+1)');
            if check == 1 && IsIntersectionPointInsideTriangle(intersectP,vertex(faces(faceIndex,:)',:))
                plot3(intersectP(1),intersectP(2),intersectP(3),'g*');
                disp('Intersection');
                intersection(q,1) = true;
            end
        end    
    end
end
% 2.5: Go through each link and also each triangle face
% for i = 1 : size(tr,3)-1        
%     for faceIndex = 1:size(faces,1)
%         vertOnPlane = vertex(faces(faceIndex,1)',:);
%         [intersectP,check] = LinePlaneIntersection(faceNormals(faceIndex,:),vertOnPlane,tr(1:3,4,i)',tr(1:3,4,i+1)');
%         if check == 1 && IsIntersectionPointInsideTriangle(intersectP,vertex(faces(faceIndex,:)',:))
%             plot3(intersectP(1),intersectP(2),intersectP(3),'g*');
%             display('Intersection');
%         end
%     end    
% end
% 
% function [jointCollision] = CheckCollision(robot, trajectory)
%     
% end

