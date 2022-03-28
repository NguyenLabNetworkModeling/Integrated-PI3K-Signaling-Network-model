function [ methodID ] = readInput( varargin )
%READINPUT


if nargin == 1,

    list    = varargin{1};

    fprintf('Please, select one from the list:\n');

elseif nargin ==2,

    list    = varargin{1};
    msg     = varargin{2};

    fprintf(msg);
end

for i=1:length(list)
    fprintf('[%d] %s \n',i,list{i});
end
methodID = input('> ');

end

