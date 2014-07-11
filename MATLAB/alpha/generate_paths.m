function paths = generate_paths(num_paths, image_dim, path_type, rad_center)
	% by default, generate random paths
    
	paths = zeros(num_paths,4);

    % we define min path length as the length of the path from a midpoint 
	% of one side to the midpoint of an adjacent side
	min_path_length = sqrt((image_dim(1)/2)^2 + (image_dim(2)/2)^2);
	%min_path_length = 0;
    
    if nargin == 2
		%disp('nothing')
        for i = 1:num_paths
			% choosing two edges of the image
			% 1 = left, 2 = top, 3 = right, 4 = bottom
			edges = randperm(4);
            edges = edges(1:2);
			point1 = get_random_point_on_edge(edges(1), image_dim);
			point2 = get_random_point_on_edge(edges(2), image_dim);							
			paths(i,:) = [point1 point2];
        end
        
    % If the path type is bouncy, then bounce from wall to wall.
	elseif strcmp(path_type, 'bouncy')
        %disp('bouncy')
        edges = randperm(4);
        edges = edges(1:2);
		point1 = get_random_point_on_edge(edges(1), image_dim);
		point2 = get_random_point_on_edge(edges(2), image_dim);							
		paths = [paths; point1 point2];
		last_edge = edges(2);
        for i = 2:num_paths,
			rand_edge = randi(4);
			% make sure we don't bounce to the same edge
			while (rand_edge == last_edge)
				rand_edge = randi(4);
			end
			point1 = point2;
			point2 = get_random_point_on_edge(rand_edge, image_dim);

			path_length = pdist([point1; point2], 'euclidean');
			while (path_length < min_path_length)
				point2 = get_random_point_on_edge(rand_edge, image_dim);
				path_length = pdist([point1; point2], 'euclidean');
			end

			last_edge = rand_edge;
			paths(i,:) = [point1 point2];
        end
        
    elseif strcmp(path_type, 'radial')

        N = image_dim(1);
        M = image_dim(2);
        
        if nargin == 3
            rad_center = [ int16(N/2) int16(M/2) ];
        end
        
        n = rad_center(1);
        m = rad_center(2);
        
        theta = (2*pi/(num_paths*2))*(0:num_paths*2-1)';
        thetaMod = mod(theta+pi/4, pi/2) - pi/4;
        r = (N-n)*thetaMod;
        
        theta0   = theta(1:numpaths);
        thetaend = theta(numpaths+1:end);
        
        r0 = r(1:numpaths);
        rend = r(numpaths+1:end);
        
        x0   = int16(r0.*sin(theta0)) + n;
        y0   = int16(r0.*cos(theta0)) + m;
        xend = int16(rend.*sin(thetaend)) + n;
        yend = int16(rend.*cos(thetaend)) + m;
        
        paths(:,:) = [ x0 y0 xend yend ];
        
    end
    

end

function point = get_random_point_on_edge(edge_num, image_dim)
	switch edge_num
	case 1
		x1 = 0;
		y1 = rand(1)*image_dim(1);
	case 2
		x1 = rand(1)*image_dim(2);
		y1 = image_dim(1);
	case 3
		x1 = image_dim(2);
		y1 = rand(1)*image_dim(1);
	case 4
		x1 = rand(1)*image_dim(2);
		y1 = 0;
	end
	point = [x1 y1];
end
