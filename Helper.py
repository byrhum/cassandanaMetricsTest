def get_regex_for_metric_value(value):
    max_split = 1
    regex_value = value
    if "." in value:
        split_value = value.split(".", max_split)
        regex_value = split_value[0]+"\\."+split_value[1]
    return regex_value


def get_value_from_metric_value_pair(metric_value_pair):
    max_split = 1
    return_value = metric_value_pair
    if " " in metric_value_pair:
        split_value = metric_value_pair.split(" ", max_split)
        return_value = split_value[1]
    return return_value

