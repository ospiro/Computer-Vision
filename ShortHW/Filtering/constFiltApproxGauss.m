gaussFilt = zeros(5,5);
normfactor = 1/(2*pi);
%create gaussian filter
for i = 1:9
    for j = 1:9
        x = j-41;
        y = 41-i;
        gaussFilt(i,j) = normfactor*exp(-0.5*(x^2 + y^2));
    end
end
%loop to compare i iterations of const filter with gauss filter. 
constFilt = (1/81)*ones(9,9);
repConstFilt = constFilt;
resids = zeros(10);
for i = 1:10
    repConstFilt = filter2(constFilt,repConstFilt,'same');
    resids(i) = sum(sum((repConstFilt-gaussFilt).^2));
end
figure
plot(1:10,resids);   