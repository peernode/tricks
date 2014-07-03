function R_factor = R_factor_func(d,Ppl)

I_eff=95*Ppl/(Ppl+25.1);

Id=1.618*10^(-13)*d^6-1.765*10^(-10)*d^5+6.447*10^(-8)*d^4-8.221*10^(-6)*d^3+0.0002315*d^2+0.0352*d-0.02434

R_factor=93.2-I_eff-Id;


if R_factor<0
R_factor=0;
end


