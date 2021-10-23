function [eff_vo] = effective_stress_calculator(z,unit_weight,zcr)

for i=1:length(z)
    if i==1
        eff_vo(i) = z(i) .* unit_weight(i);
    elseif zcr==z(i)
        eff_vo(i) = eff_vo(i-1) + (z(i)-z(i-1))*(unit_weight(i)-9.81);
        eff_vo(i:length(z)) = eff_vo(i);
        break
    else
        eff_vo(i) = eff_vo(i-1) + (z(i)-z(i-1))*(unit_weight(i)-9.81);
       
    end
end

end

