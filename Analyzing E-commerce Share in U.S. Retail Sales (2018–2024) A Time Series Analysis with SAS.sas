data retail_sales;
    infile datalines dlm=',' dsd truncover;
    input Quarter :$30. Total_Sales :comma12. Ecommerce_Sales :comma12.;
    datalines;
1st quarter 2018,1214805,111690
2nd quarter 2018,1328390,119597
3rd quarter 2018,1314963,120554
4th quarter 2018,1395223,155545
1st quarter 2019,1230871,121578
2nd quarter 2019,1366265,132399
3rd quarter 2019,1363013,138655
4th quarter 2019,1441321,178456
1st quarter 2020,1256799,146491
2nd quarter 2020,1316319,204062
3rd quarter 2020,1452064,204806
4th quarter 2020,1540531,255399
1st quarter 2021,1460263,213993
2nd quarter 2021,1677723,232425
3rd quarter 2021,1630377,224757
4th quarter 2021,1751482,279852
1st quarter 2022,1614851,229465
2nd quarter 2022,1809731,244065
3rd quarter 2022,1776015,245114
4th quarter 2022,1840398,293992
1st quarter 2023,1671884,247176
2nd quarter 2023,1820322,264857
3rd quarter 2023,1815346,268745
4th quarter 2023,1892581,322862
1st quarter 2024,1717431,267976
2nd quarter 2024,1853622,282628
3rd quarter 2024,1852750,289049
4th quarter 2024,1977217,352935
;
run;

data retail_sales_clean;
    set retail_sales;
    retain Date_Seq 0;

    /* Calculate E-commerce Share */
    Ecommerce_Share = (Ecommerce_Sales / Total_Sales) * 100;

    /* Parse Year */
    if find(Quarter, '2024') then Year = 2024;
    else if find(Quarter, '2023') then Year = 2023;
    else if find(Quarter, '2022') then Year = 2022;
    else if find(Quarter, '2021') then Year = 2021;
    else if find(Quarter, '2020') then Year = 2020;
    else if find(Quarter, '2019') then Year = 2019;
    else if find(Quarter, '2018') then Year = 2018;

    /* Parse Quarter */
    if find(Quarter, '1st') then Qtr = 1;
    else if find(Quarter, '2nd') then Qtr = 2;
    else if find(Quarter, '3rd') then Qtr = 3;
    else if find(Quarter, '4th') then Qtr = 4;

    /* Incremental sequence for plotting */
    Date_Seq + 1;

    /* Create label like Q1 2024 */
    Quarter_Label = cats("Q", Qtr, " ", Year);
run;

proc sgplot data=retail_sales_clean;
    title "Total vs. E-commerce Retail Sales (2018–2024)";
    series x=Quarter_Label y=Total_Sales / lineattrs=(color=blue) markers legendlabel="Total Sales";
    series x=Quarter_Label y=Ecommerce_Sales / lineattrs=(color=red) markers legendlabel="E-commerce Sales";
    xaxis label="Quarter" discreteorder=data fitpolicy=rotate valuesrotate=diagonal;
    yaxis label="Sales (in millions USD)";
    keylegend / position=topright;
run;

proc sgplot data=retail_sales_clean;
    title "E-commerce Share of Total U.S. Retail Sales (2018–2024)";
    series x=Quarter_Label y=Ecommerce_Share / lineattrs=(color=green) markers;
    xaxis label="Quarter" discreteorder=data fitpolicy=rotate valuesrotate=diagonal;
    yaxis label="E-commerce Share (%)";
run;
