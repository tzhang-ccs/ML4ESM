import torch
import torch.nn as nn

class MHI_CNN(nn.Module):
    def __init__(self):
        super(MHI_CNN, self).__init__()

        self.conv1 = nn.Conv2d(1, 32, kernel_size=3, padding=1)
        self.conv2 = nn.Conv2d(32, 64, kernel_size=3, padding=1)
        self.conv3 = nn.Conv2d(64, 128, kernel_size=3, padding=1)
        self.conv4 = nn.Conv2d(128, 256, kernel_size=3, padding=1)

        # Define the pooling layer
        self.pool = nn.MaxPool2d(kernel_size=1)

        # Define the fully connected layers
        self.fc1 = nn.Linear(256*72*3, 128)
        self.fc2 = nn.Linear(4,128)
        self.fc3 = nn.Linear(256, 1)

        # Define the dropout layer
        self.dropout = nn.Dropout(0.5)

    def forward(self, x):
        # Split the input data into multiple heads
        x1, x2 = x

        # Apply the convolutional layers to each input head
        x1 = self.conv1(x1)
        x1 = nn.functional.relu(x1)
        x1 = self.pool(x1)

        x1 = self.conv2(x1)
        x1 = nn.functional.relu(x1)
        x1 = self.pool(x1)

        x1 = self.conv3(x1)
        x1 = nn.functional.relu(x1)
        x1 = self.pool(x1)

        x1 = self.conv4(x1)
        x1 = nn.functional.relu(x1)
        x1 = self.pool(x1)

        x1 =  x1.view(-1,256*72*3)
        x1 = self.fc1(x1)

        x2 = self.fc2(x2)
        x1x2 = torch.cat((x1,x2),dim=1)

        output = self.fc3(x1x2)

        return output
