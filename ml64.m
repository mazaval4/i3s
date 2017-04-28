% Import the database as 2 dimensional array
system('taskkill /F /IM EXCEL.EXE');
data = xlsread('[S2 v2] i3s Database & Results Z-scored.xlsm');
%data = xlsread('[S2 v2] i3s Database & Results raw.xlsm');
imported_data = data;
%data = 0; % This should release the excel file for other programs.

% NEURONS 
input_neurons=5;    %input neurons
hidden_neurons=6;   %first hidden layer neurons
output_neurons=5;   %output neurons


learning_rate=.50;

activation_output = 0;

weight_multiplier = 1;

noOfIteration = 1;

variation_array = [.50];

syms x;
f(x) = 2/(1+exp(-2*x))-1;
df = diff(f,x);

current_row = 1;
total_rows = 525;
% Training the neural network uses 80% of data
training_rows = .80 * total_rows;
training_x_plot = 1:1:training_rows;

for p=1:1:length(variation_array)
    %Adjust something by p
	learning_rate = variation_array(p);
	
    % INPUT and OUTPUT ARRAYS
    in_vector=zeros(1,output_neurons);
    out_vector=zeros(1,output_neurons);

    % HIDDEN LAYER OUTPUT    
    hide1_neuron_out=zeros(1,hidden_neurons);

    % OUTPUT LAYER DELTA: Difference between expected and calculated
    delta_output=zeros(1,output_neurons);

    % DELTA HIDDEN
    delta_hidden = zeros(1,hidden_neurons);

    % PRESENT WEIGHTS (pw)
    pw_ih=randn(input_neurons,hidden_neurons)*weight_multiplier;
    ptheta_h1=randn(1,hidden_neurons)*weight_multiplier;
    pw_ho=randn(hidden_neurons,output_neurons)*weight_multiplier;
    ptheta_o=randn(1,output_neurons)*weight_multiplier; %Later check out a fixed range

    % FUTURE
    next.w_ih=zeros(input_neurons,hidden_neurons);
    next.theta_h1=zeros(1,hidden_neurons);
    next.w_ho=zeros(hidden_neurons,output_neurons);
    next.theta_o=zeros(1,output_neurons);

    training_percent_error = 0;
    for iteration=1:1:noOfIteration
		%Reset current_row for new iteration
		current_row = 1;
        figure;
        hold on;
        weights_old=plot(0,0);
        %********** TRAINING LOOP ******************************
        while current_row <= training_rows
            
            %Load data into temporary input and output arrays
            for i=2:1:6
                in_vector(1,i-1) = imported_data(current_row, i);
                out_vector(1,i-1) = imported_data(current_row, (i+5));
            end

            %*********** COMPUTING INPUT FOR HIDDEN LAYER *************

            % Start at 1, step by 1, and end at 5
            for j=1:1:hidden_neurons

               neuron_input=0;

               % Start at 1, step by 1, and end at input_neurons
               for i=1:1:input_neurons

                   % Multiply the input value by the hidden layer weight
                   neuron_input = neuron_input+in_vector(1,i)*pw_ih(i,j);

               end

               % Add the hidden layer theta value
               neuron_input= neuron_input+ptheta_h1(j);

               % F ACTIVATION FUNCTION
               x=neuron_input;
               activation_output=f(x);

               %SETTING THE OUTPUTS OF THE HIDDEN LAYER
               hide1_neuron_out(1,j)= activation_output;
            end

            %********* COMPUTING THE INPUT FOR THE OUTPUT LAYER ************
            % Start at 1, step by 1, end at 5
            for j=1:1:output_neurons %compute input to output layer
                neuron_input=0;

                % Start at 1, step by 1, end at # of hidden neurons
                for i=1:1:hidden_neurons

                    % Multiply hidden output by weight
                    neuron_input=neuron_input+hide1_neuron_out(1,i)*pw_ho(i,j);

                end

                % Add output theta value
                neuron_input= neuron_input+ptheta_o(j);

                %factivation (same as previous)
                x=neuron_input; 
                activation_output=f(x);

                % Error = desired (y) - calculated (y_a)
                delta_output(1,j) = out_vector(1,j) - activation_output;
            end
            
            %************* BACKPROPAGATE THE ERRORS***************

            %************Getting Hidden Layer Deltas
            for k=1:1:hidden_neurons
                delta_sum = 0;
                for n=1:1:output_neurons
                    delta_sum = delta_sum + delta_output(1,n) * pw_ho(k,n);
                end
                delta_hidden(1,k)= delta_sum;
            end



            %******Updating Weights between input and hidden layer
            for k = 1: 1: hidden_neurons
                for n = 1: 1: input_neurons
                    x = hide1_neuron_out(1,k);
                    next.w_ih(n, k) = pw_ih(n, k) + learning_rate*delta_hidden(1,n)*df(x)*in_vector(1, n);
                end
            end

            %******Updating Weights between hidden layer and output
            x = neuron_input;
            for k = 1: 1: output_neurons
                for n = 1: 1: hidden_neurons
                    next.w_ho(n, k) = pw_ho(n, k) + learning_rate*delta_output(1,k)*df(x)*hide1_neuron_out(1,n);
                end
            end


            %******Make the present weights, the Next weights********
            %These weights produce the best results when only one is
            %uncommented
            pw_ih = next.w_ih;
            %pw_ho = next.w_ho;
            
            %Alternate updating weights
%             if mod(current_row, 2) == 0
%                 pw_ih = next.w_ih;
%             else
%                 pw_ho = next.w_ho;
%             end
            
            weights=plot(pw_ih.', pw_ho);
            %weights=plot(training_x_plot(1:current_row), det(pw_ih));
            delete(weights_old);
            weights_old=weights;
            drawnow;

            % Increment the row
            current_row = current_row + 1;
            %fprintf('Iteration: %d; Row: %d\n', iteration, current_row);
            %fprintf('   IH-Weights: %d\n', pw_ih);
            %fprintf('   HO-Weights: %d\n', pw_ho);
            fprintf('.');
        end
        fprintf('\n');
    end
    
    % FINAL TRAINING ERROR CHECK LOOP 
    current_row = 1;
    %********** TRAINING LOOP ******************************
    while current_row <= training_rows
        %Load data like before
        for i=2:1:6
            in_vector(1,i-1) = imported_data(current_row, i);
            out_vector(1,i-1) = imported_data(current_row, (i+5));
        end

        %******************* TESTING TRAINING DATA *******************

        training_percent_error = 0;

        % COMPUTING INPUT FOR HIDDEN LAYER

        % Start at 1, step by 1, and end at 5
        for j=1:1:hidden_neurons

           neuron_input=0;

           % Start at 1, step by 1, and end at 4
           for i=1:1:input_neurons

               % Multiply the input value by the hidden layer weight
               neuron_input = neuron_input+in_vector(1,i)*pw_ih(i,j);

           end

           % Add the hidden layer theta value
           neuron_input= neuron_input+ptheta_h1(j);

           % F ACTIVATION FUNCTION
           x=neuron_input;
           activation_output=f(x);
        end

        % SETTING THE OUTPUTS OF THE HIDDEN LAYER

        hide1_neuron_out(1,j)= activation_output;

        %********* COMPUTING THE INPUT FOR THE OUTPUT LAYER *****

        % Start at 1, step by 1, end at 5
        for j=1:1:output_neurons %compute input to output layer
            neuron_input=0;

            % Start at 1, step by 1, end at # of hidden neurons
            for i=1:1:hidden_neurons

                % Multiply hidden output by weight
                neuron_input=neuron_input+hide1_neuron_out(1,i)*pw_ho(i,j);

            end

            % Add output theta value
            neuron_input= neuron_input+ptheta_o(j);

            % activation (same as previous)
            x=neuron_input; 
            activation_output=f(x);

            % Error = desired (y) - calculated (y_a)
            delta_output(1,j)=out_vector(1,j)-activation_output;

            if out_vector(1,j) ~= 0
                % percent_error=the absolute value of (calc - desired)/desired *100
                percent_error = abs( (activation_output - out_vector(1,j) ) / out_vector(1,j) ) * 100;                
            elseif activation_output ~= 0
                percent_error = 1;
            else
                percent_error = 0;
            end
            %fprintf('Percent Error: %0.2f\n', percent_error);
            training_percent_error = training_percent_error + percent_error;
        end
        
        current_row = current_row + 1;
        %fprintf('%d\n', current_row);
    end
     fprintf('\nTraining Percent Error: %0.2f\n', training_percent_error/(training_rows*output_neurons));
   % TESTING LOOP
    while current_row < total_rows

        %Load data like before
        for i=2:1:6
            in_vector(1,i-1) = imported_data(current_row, i);
            out_vector(1,i-1) = imported_data(current_row, (i+5));
        end

        %******************* TESTING *******************

        total_percent_error = 0;

        % COMPUTING INPUT FOR HIDDEN LAYER

        % Start at 1, step by 1, and end at 5
        for j=1:1:hidden_neurons

           neuron_input=0;

           % Start at 1, step by 1, and end at 4
           for i=1:1:input_neurons

               % Multiply the input value by the hidden layer weight
               neuron_input = neuron_input+in_vector(1,i)*pw_ih(i,j);

           end

           % Add the hidden layer theta value
           neuron_input= neuron_input+ptheta_h1(j);

           % F ACTIVATION FUNCTION
           x=neuron_input; 
           activation_output=f(x);
        end

        % SETTING THE OUTPUTS OF THE HIDDEN LAYER

        hide1_neuron_out(1,j)= activation_output;

        %********* COMPUTING THE INPUT FOR THE OUTPUT LAYER *****

        % Start at 1, step by 1, end at 5
        for j=1:1:output_neurons %compute input to output layer
            neuron_input=0;

            % Start at 1, step by 1, end at # of hidden neurons
            for i=1:1:hidden_neurons

                % Multiply hidden output by weight
                neuron_input=neuron_input+hide1_neuron_out(1,i)*pw_ho(i,j);

            end

            % Add output theta value
            neuron_input= neuron_input+ptheta_o(j);

            % activation (same as previous)
            x=neuron_input; 
            activation_output=f(x);

            % Error = desired (y) - calculated (y_a)
            delta_output(1,j)=out_vector(1,j)-activation_output;

            if out_vector(1,j) ~= 0
                % percent_error=the absolute value of (calc - desired)/desired *100
                percent_error = abs( (activation_output - out_vector(1,j) ) / out_vector(1,j) ) * 100;                
            elseif activation_output ~= 0
                percent_error = 1;
            else
                percent_error = 0;
            end
            %fprintf('Percent Error: %0.2f\n', percent_error);
            total_percent_error = total_percent_error + percent_error;
        end

        current_row = current_row + 1;
        %fprintf('%d\n', current_row);
        fprintf(',');
    end


    % After the testing loop...
    % get the average percent error: the total percent error divided by 1/5th of the 525 total points
    average_percent_error = total_percent_error /((output_neurons)*(total_rows-training_rows));
    fprintf('\nTotal Percent Error: %0.2f; Iterations: %d; Learning rate: %0.2f; Neurons: %d; weight_multiplier: %0.2f\n', average_percent_error, noOfIteration, learning_rate, hidden_neurons, weight_multiplier);   
    fprintf('Weights: ih:\n');
    disp(pw_ih);
    fprintf('ho:\n');
    disp(pw_ho);
end
