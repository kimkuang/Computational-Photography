function two_image_stitching(check_homo,check_stitch)
    reference_frame=450;
    source_frame = 270;
    % Image input
    R=im2single(imread(sprintf('frames/f%04d.jpg',reference_frame)));
        Ho = auto_homography(R,R);
        To = maketform('projective', Ho'); 
        base = imtransform(R, To, 'XData',[-651 980],'YData',[-51 460]); 

    % Computing homography and projection
    S=im2single(imread(sprintf('frames/f%04d.jpg',source_frame)));
        H = auto_homography(R,S);
        T = maketform('projective', H'); 
        toadd = imtransform(S, T, 'XData',[-651 980],'YData',[-51 460]);
        if (check_homo)
            check_homography(H,R,S);
        end

    % Neighboring image stitch
    output = neighborStitch(toadd,base,base);
        if (check_stitch)
            figure(2),imshow(output),title('output panorama');
        end
end