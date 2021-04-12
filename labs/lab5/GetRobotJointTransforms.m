function [jointTransforms] = GetRobotJointTransforms(robot, q)
    jointTransforms = zeros(4,4,robot.n + 1);
    jointTransforms(:, :, 1) = robot.base;
    L = robot.links;
    for i = 1:1:robot.n
        jointTransforms(:,:,i+1) = robot.base;
        for j = 1:1:i
            jointTransforms(:,:,i+1) = jointTransforms(:,:,i+1) * trotz(q(i)+L(i).offset) + transl(0,0,L(i).d) * transl(L(i).a,0,0) * trotx(L(i).alpha);
        end
    end
end