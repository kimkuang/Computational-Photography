function hdr = makehdr_overunder(ldrs, exposures,cut_expo)
    % ldrs is an m x n x 3 x k matrix which can be created with ldrs = cat(4, ldr1, ldr2, ...);
    % exposures is a vector of exposure times (in seconds) corresponding to ldrs
    [exposures,sortexp] = sort(reshape(exposures,1,1,1,[]));
    ldrs = ldrs(:,:,:,sortexp); %Sort exposures from dark to light

    %Create naive HDR here
    len = length(sortexp);
    sum = zeros(size(ldrs(:,:,:,1)));
    sum_mask = zeros(size(ldrs(:,:,:,1)));
    for i = 1:len
        toadd = ldrs(:,:,:,i);
        % find the properly exposed pixels
        gray = rgb2gray(toadd);
        notOverExpo = gray<(1-cut_expo);
        notUnderExpo = gray> cut_expo;
        mask = notOverExpo & notUnderExpo;
        mask = double(repmat(mask,[1,1,3]));
        % adding up to average
        inRange = (toadd.*mask)./exposures(i);
        sum = sum + log(inRange);
%         sum = sum+(log(ldrs(:,:,:,i)./exposures(i)).*mask);
        minofsum = min(sum(:))
        h = (ldrs(:,:,:,i)./exposures(i));
        minoflog = min(h(:))
        imshow(toadd);
        pause;
        sum_mask = sum_mask + mask;
    end
    hdr =sum ./ sum_mask;

    sum_mask = logical(sum_mask);
    hdr = exp(hdr).*sum_mask;
%     hdr = hdr.* logical(sum_mask);
end