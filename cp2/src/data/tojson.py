import csv
import json

data = {
    'name': 'allegations',
    'children': []
}

categories = []

with open('allegation_cat_first_name.csv') as f:
    reader = csv.reader(f, delimiter=',')
    next(reader)
    for row in reader:
        category = row[0]
        name = row[1]
        count = int(row[2])
        print(category, name, count)

        if category not in [c['name'] for c in categories]:
            cat = {}
            cat['name'] = category
            children = []
            children.append({
                'name': name,
                'value': count
            })
            cat['children'] = children
            categories.append(cat)
        else:
            cat = categories[[c['name'] for c in categories].index(category)]
            if name not in [n['name'] for n in cat['children']]:
                cat['children'].append({
                    'name': name,
                    'value': count
                })

data['children'] = categories
with open('cat_first.json', 'w') as outfile:
    json.dump(data, outfile, indent=4)

