import os

# 获取当前目录路径
source_dir = './labels'

labels_list = []
for item in os.listdir(source_dir):
    item_path = os.path.join(source_dir, item)
    if os.path.isfile(item_path):
        labels_list.append(os.path.splitext(item)[0])
        #print(f"{item}")

#print(labels_list)

# 获取当前目录路径
dst_dir  = './images'

for item in os.listdir(dst_dir):
    item_path = os.path.join(dst_dir, item)
    if os.path.isfile(item_path):
        filename = os.path.splitext(item)[0]
        if filename not in labels_list:
            #print(filename)
            os.remove(item_path)
            print(f"{item_path}")

