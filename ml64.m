% Import the database as 2 dimensional array
data = xlsread('[S2 v2] i3s Database & Results raw.xlsm');

% NEURONS 
input_neurons=5;         %input neurons
hidden_neurons=5;        %first hidden layer neurons
output_neurons=5;          %output neurons

% INPUT, HIDDEN LAYER, and OUTPUT ARRAYS
in_vector=zeros(1,output_neurons);
hide1_vector=zeros(1,hidden_neurons);
out_vector=zeros(1,output_neurons);

% ARRAYS OF RANDOM WEIGHTS BETWEEN EACH LAYER
w0=randn(input_neurons,hidden_neurons)*0.001;   
w2=randn(hidden_neurons,output_neurons)*0.001;


% HIDDEN LAYER OUTPUT    
hide1_neuron_out=zeros(1,hidden_neurons);

% HIDDEN LAYER DELTA: Difference between expected and calculated   
delta_ih=zeros(1,hidden_neurons);

% ERROR ARRAY
delta_output=zeros(1,output_neurons);

% DELTA HIDDEN
delta_hidden = zeros(1,hidden_neurons);

% OUTPUT LAYER DELTA: Difference between expected and calculated
delta_o=zeros(1,output_neurons);

% PRESENT WEIGHTS (pw)
pw_ih=randn(input_neurons,hidden_neurons)*0.001;
ptheta_h1=randn(1,hidden_neurons)*0.001;
pw_ho=randn(hidden_neurons,output_neurons)*0.001;
ptheta_o=randn(1,output_neurons)*0.001; %Later check out a fixed range

% FUTURE
next.w_ih=zeros(input_neurons,hidden_neurons);
next.theta_h1=zeros(1,hidden_neurons);
next.w_ho=zeros(hidden_neurons,output_neurons);
next.theta_o=zeros(1,output_neurons);


learning_rate=.2;

activation_output = 0; 
%*****************************************************Fix this, its an error
%work with present

current_row = 1;
total_rows = 525;
% Training the neural network uses 80% of data
training_rows = .80 * total_rows;

%********** TRAINING LOOP ******************************
while current_row <= training_rows

	%Load data into temporary input and output arrays
	for i=2:1:6
		in_vector(1,i-1) = data(current_row, i);
		out_vector(1,i-1) = data(current_row, (i+5));
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
	   activation_output=1/(1+exp(-1*neuron_input));
       
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
		activation_output=1/(1+exp(-1*neuron_input));

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


	%************Replace diff with symbolic eq*****************
    
    syms x;
    f(x) = 1/(1+exp(-1*x));
    df = diff(f,x);
            
	%******Updating Weights between input and hidden layer
	for k = 1: 1: hidden_neurons
        for n = 1: 1: input_neurons
            x = hide1_neuron_out(1,k);
			next.w_ih(n, k) = pw_ih(n, k) + learning_rate*delta_hidden(1,n)*df(x)*in_vector(1, n);
		end
	end

	%******Updating Weights between hidden layer and output
	%Check this late, throws an error
	%Subscripted assignment dimension mismatch.
    x = neuron_input;

    for k = 1: 1: output_neurons
		for n = 1: 1: hidden_neurons
			next.w_ho(n, k) = pw_ho(n, k) + learning_rate*delta_output(1,n)*df(x)*hide1_neuron_out(1,n);
		end
	end

	
	%******Make the present weights, the Next weights********
	pw_ih = next.w_ih;
	pw_oh = next.w_ho;

	% Increment the row
	current_row = current_row + 1;
	fprintf('%d\n', current_row);
end


% TESTING LOOP
while current_row < total_rows

	%Load data like before
	for i=2:1:6
		in_vector(1,i-1) = data(current_row, i);
		out_vector(1,i-1) = data(current_row, (i+5));
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
	   activation_output=1/(1+exp(-1*neuron_input));
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
		activation_output=1/(1+exp(-1*neuron_input));

		% Error = desired (y) - calculated (y_a)
		delta_output(1,j)=out_vector(1,j)-activation_output;

        if out_vector(1,j) ~= 0
            % percent_error=the absolute value of (calc - desired)/desired *100
            percent_error = abs( (activation_output - out_vector(1,j) ) / out_vector(1,j) ) * 100;
            fprintf('Percent Error: %0.2f\n', percent_error);
            total_percent_error = total_percent_error + percent_error;
        end
	end

	current_row = current_row + 1;
	fprintf('%d\n', current_row);
end
	
	
% After the testing loop...
% get the average percent error: the total percent error divided by 1/5th of the 525 total points
average_percent_error = total_percent_error / 105*5;
fprintf('Total Percent Error: %0.2f\n', average_percent_error);   
