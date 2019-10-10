SELECT AVG(allegation_count) as avg_total,
        AVG(year_zero_allegation_count) as year_zero,
        AVG(year_one_allegation_count) as year_one,
        AVG(year_two_allegation_count)  as year_two,
        AVG(year_three_allegation_count) as year_three,
        AVG(year_four_allegation_count) as year_four,
        AVG(year_five_allegation_count) as year_five,
        AVG(year_six_allegation_count)  as year_six,
        AVG(year_seven_allegation_count) as year_seven,
        AVG(year_eight_allegation_count) as year_eight,
        AVG(year_nine_allegation_count) as year_nine,
        AVG(year_ten_allegation_count) as year_ten
FROM officer_subset;