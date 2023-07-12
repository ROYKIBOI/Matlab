function isBird = isBird(subImage)
    % Load pre-trained AlexNet model
    net = alexnet;

    % Preprocess the sub-image for input to the network
    subImage = imresize(subImage, net.InputSize(1:2));
    subImage = preprocessInput(subImage);

    % Use the pre-trained model to classify the sub-image
    scores = classify(net, subImage);

    % Check if the top predicted class is a bird
    topClass = char(scores(1));
    if contains(topClass, 'bird', 'IgnoreCase', true)
        isBird = true;
    else
        isBird = false;
    end
end

function preprocessedImage = preprocessInput(image)
    % Resize the image to the input size of the pre-trained network
    preprocessedImage = imresize(image, [227, 227]);

    % Convert the image to the format expected by the network (e.g., RGB)
    if size(preprocessedImage, 3) == 1
        preprocessedImage = repmat(preprocessedImage, [1, 1, 3]);
    end

    % Perform any other necessary preprocessing steps (e.g., normalization)
    preprocessedImage = im2single(preprocessedImage);
end
