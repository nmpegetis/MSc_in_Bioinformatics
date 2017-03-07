function [superClass] = normalize(superClass)
    superClass = superClass';
    superClass = mapstd(superClass);
    superClass = superClass';
end