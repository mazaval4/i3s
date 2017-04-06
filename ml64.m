% EXCEL DATABASE JUNNK
data = xlsread('[S2 v2] i3s Database & Results raw.xlsm');

% NEURONS 
input_neurons=4;         %input neurons
hidden_neurons=5;        %first hidden layer neurons
output_neurons=5;          %output neurons

% INPUT, HIDDEN LAYER, and OUTPUT ARRAYS
in_vector=zeros(1,input_neurons);
hide1_vector=zeros(1,hidden_neurons);
out_vector=zeros(1,output_neurons);

% ARRAYS OF RANDOM WEIGHTS BETWEEN EACH LAYER
w0=randn(input_neurons,hidden_neurons)*0.001;   
w2=randn(hidden_neurons,output_neurons)*0.001;

% OUTPUT MATRIX (INITIALIZED TO ZERO)
outmatrix=zeros(540,output_neurons); 
%30 students * 18 data points = 540

% THETA
theta_h1=randn(1,hidden_neurons)*0.001;   
theta_o=randn(1,output_neurons)*0.001;

% HIDDEN LAYER OUTPUT    
hide1_neuron_out=zeros(1,hidden_neurons);

% HIDDEN LAYER DELTA: Difference between expected and calculated   
delta_ih=zeros(1,hidden_neurons);

% ERROR ARRAY
delta_output=zeros(1,output_neurons);

% INPUT AND OUTPUT ARRAYS   
x=zeros(1,input_neurons);    
y=zeros(1,output_neurons);

% (D)ESIRED OUTPUT VALUE
d=0;

% OUTPUT LAYER DELTA: Difference between expected and calculated
delta_o=zeros(1,output_neurons);

% PRESENT WEIGHTS (pw)
pw_ih=randn(input_neurons,hidden_neurons)*0.001;
ptheta_h1=randn(1,hidden_neurons)*0.001;
pw_ho=randn(hidden_neurons,output_neurons)*0.001;
ptheta_o=randn(1,output_neurons)*0.001; %Later check out a fixed range

% PAST
old.w_ih=zeros(input_neurons,hidden_neurons);
old.theta_h1=zeros(1,hidden_neurons);
old.w_ho=zeros(hidden_neurons,output_neurons);
old.theta_o=zeros(1,output_neurons);

% FUTURE
next.w_ih=zeros(input_neurons,hidden_neurons);
next.theta_h1=zeros(1,hidden_neurons);
next.w_ho=zeros(hidden_neurons,output_neurons);
next.theta_o=zeros(1,output_neurons);

% ETA AND ALFA (ALPHA?)
eta1=0.62;
eta2=0.62;
eta3=0.62;
alfa=0.1;
learning_rate=0.69;

activation_output =; 
%*****************************************************Fix this, its an error
%work with present

%for each data point (line in the database), do the following
current_row = 0;
total_rows = 525;
training_rows = .80 * total_rows;

% Training Section (First 80% of data)
while current_row <= training_rows
	
	% Load data into temporary input and output arrays
	for i=1:1:5
		in_vector(1,i-1) = data(current_row, i);
		out_vector(1,i-1) = data(current_row, (i+5));
	end
	
	% Training goes here
	
	% COMPUTING INPUT FOR HIDDEN LAYER

	% Start at 1, step by 1, and end at 5
	for j=0:1:hidden_neurons
	   
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

	%*****************************************************
	   
	% COMPUTING THE INPUT FOR THE OUTPUT LAYER

	% Start at 1, step by 1, end at 5
	for j=0:1:output_neurons %compute input to output layer
		neuron_input=0;
		
		% Start at 1, step by 1, end at # of hidden neurons
		for i=0:1:hidden_neurons
		
			% Multiply hidden output by weight
			neuron_input=neuron_input+hide1_neuron_out(1,i)*pw_ho(i,j);

		end

		% Add output theta value
		neuron_input= neuron_input+ptheta_o(j);
	   
		%factivation (same as previous)
		activation_output=1/(1+exp(-1*neuron_input));
	end

	% Y = OUTPUT, A = ACTIVATION ? NOT SURE
	y_a(j,l)= activation_output;

	% Error = desired (y) - calculated (y_a)
	delta_output(1,j)=out_vector(1,j)-y_a(j,l);
	%********************** 



	%************* BACKPROPAGATE THE ERRORS***************

	% delta_input = zeros(1,input_neurons);
	delta_hidden = zeros(1,hidden_neurons);
	%************Getting Hidden Layer Deltas
	for k=0:1:hidden_neurons
		delta_sum = 0;
		
		for n=0:1:output_neurons
			delta_sum = delta_sum + delta_output(1,n) * pw_ho(k,n);
		end
		
		delta_hidden(1,k)= delta_sum;
	end

	%************Replace diff with symbolic eq*****************


	%******Updating Weights between input and hidden layer
	for k = 0: 1: hidden_neurons
		for n = 0: 1: input_neurons
			next.w_ih(n, k) = pw_ih(n, k) + learning_rate*delta_hidden(1,n)*diff(1/(1+exp(-1*hide1_neuron_out(1,k) )))*in_vector(1, n);
		end
	end

	%******Updating Weights between hidden layer and output
	for k = 1: 1: output_neurons
		for n = 1: 1: hidden_neurons
			next.w_ho(n, k) = pw_ho(n, k) + learning_rate*delta_output(1,n)*diff(1/(1+exp(-1*neuron_input)))*hide1_neuron_out(1,n);
		end
	end

	%******Make the present weights, the Next weights********

	pw_ih = next.w_ih;
	pw_oh = next.w_oh;

	%----------------------------------------------------------
	
	current_row = current_row + 1;
	
end

while current_row <= total_rows
	% Load data again
	for i=1:1:5
		in_vector(1,i) = data(current_row, i);
		out_vector(1,i) = data(current_row, (i+5));
	end

	% Testing goes here
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
	   
		%factivation (same as previous)
		activation_output=1/(1+exp(-1*neuron_input));
	end

	% Y = OUTPUT, A = ACTIVATION ? NOT SURE
	y_a(j,l)= activation_output;

	% Error = desired (y) - calculated (y_a)
	delta_output(1,j)=out_vector(1,j)-y_a(j,l);
	% Perhaps we should change this to be a % difference equation

	%percent_error=the absolute value of calc - desired/desired *100
	percent_error = abs( ( y_a(j,l) - out_vector(1,j) ) / out_vector(1,j) ) * 100;
	fprintf('Percent Error: %0.2f\n', percent_error);   


	% Add all deltas 
	for h=1:1:output_neurons
		total_percent_error = total_percent_error + delta_output;
	end


	% After the testing loop...
	% get the average percent error
	average_percent_error = total_percent_error / 108;
	fprintf('Total Percent Error: %0.2f\n', average_percent_error);   

		
			
	pw_ih=next.w_ih;
	pw_hh=next.w_hh;
	pw_ho=next.w_ho;
	
	current_row = current_row + 1;
end





%Should the bias change? I thought it was supposed to be const.
ptheta_h1=next.theta_h1;
ptheta_h2=next.theta_h2;
ptheta_o=next.theta_o;

