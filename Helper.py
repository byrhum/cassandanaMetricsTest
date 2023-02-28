def get_regex_for_metric_value(value):
    max_split = 1
    global regex_value
    regex_value = value
    print("test : "+value)
    if "." in value:
        split_value = value.split(".", max_split)
        regex_value = split_value[0]+"\\."+split_value[1]
    print("return :"+regex_value)
    return regex_value
