% EXCEL DATABASE JUNNK
data = xlsread('[S2 v2] i3s Database & Results raw.xlsm');

% NEURONS 
input_neurons=4;         %input neurons
hidden_neurons=5;        %first hidden layer neurons
output_neurons=5;          %output neurons

% INPUT, HIDDEN LAYER, and OUTPUT ARRAYS
in_vector=zeros(1,output_neurons);
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

activation_output; %*****************************************************Fix this, its an error
%work with present

%for each data point (line in the database), do the following

% COMPUTING INPUT FOR HIDDEN LAYER

% Start at 1, step by 1, and end at 5
for j=1:1:hidden_neurons
   
   neuron_input=0;
   
   % Start at 1, step by 1, and end at 4
   for i=1:1:input_neurons

       % Multiply the input value by the hidden layer weight
       neuron_input = neuron_input+x(1,i)*pw_ih(i,j);

   end

   % Add the hidden layer theta value
   neuron_input= neuron_input+ptheta_h1(j);

   % F ACTIVATION FUNCTION
   activation_output=1/(1+exp(-1*neuron_input));
end

% SETTING THE OUTPUTS OF THE HIDDEN LAYER

hide1_neuron_out(1,j)= activation_output;
%********************** 
%*****************************************************
   
% COMPUTING THE INPUT FOR THE OUTPUT LAYER

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
%l will be replaced later with a for loop variable
%for now it is an error
y_a(j,l)= activation_output;

% Error = desired (y) - calculated (y_a)
delta_output(1,j)=y(1,j)-y_a(j,l);
% Perhaps we should change this to be a % difference equation

%********************** 



%************* BACKPROPAGATE THE ERRORS***************

% delta_input = zeros(1,input_neurons);
delta_hidden = zeros(1,hidden_neurons);
%************Getting Hidden Layer Deltas
%for now this does not work because the l is not defined yet. see
%above comment for reference
for k=1:1:hidden_neurons
    delta_sum = 0;
    for n=1:1:output_neurons
        delta_sum = delta_sum + delta_output(1,n) * pw_ho(k,n);
    end
    delta_hidden(1,k)= delta_sum;
end

% for k=1:1:input_neurons
%     delta_sum = 0;
%     for n=1:1:hidden_neurons
%         delta_sum = delta_sum + delta_hidden(1,n) * pw_ih(k,n);
%     end
%     delta_input(1,k)= delta_sum;
% end

%*************************************************************************
%************************Replace diff with symbolic eq*********************
%*************************************************************************
%******Updating Weights between input and hidden layer
%database input give it an error for now until we link the database
for k = 1: 1: hidden_neurons
    for n = 1: 1: input_neurons
        next.w_ih(n, k) = pw_ih(n, k) + learning_rate*delta_hidden(1,n)*diff(1/(1+exp(-1*hide1_neuron_out(1,k) )))*database_input;
    end
end

%******Updating Weights between hidden layer and output
%Check this late, throws an error
%Subscripted assignment dimension mismatch.
for k = 1: 1: output_neurons
    for n = 1: 1: hidden_neurons
        next.w_ho(n, k) = pw_ho(n, k) + learning_rate*delta_output(1,n)*diff(1/(1+exp(-1*neuron_input)))*hide1_neuron_out(1,n);
    end
end

%----------------------------
	
        % %updating the weights between (second)hidden layer& output layer
        % for j=1:1:output_neurons 
        %      delta_o(1,j)=y_a(j,l)*(1-y_a(j,l))*delta_output(j);
        % end
        %  
        % for j=1:1:output_neurons
        %       
        %      for i=1:1:max_k2 
        %          next.w_ho(i,j)=pw_ho(i,j)+eta3*delta_o(1,j)*(hide2_neuron_out(1,i))+alfa*(pw_ho(i,j)-old.w_ho(i,j));
        %      end
        %      
        %      next.theta_o(1,j)=ptheta_o(1,j)+eta3*delta_o(1,j)+alfa*(ptheta_o(1,j)-old.theta_o(1,j));
        %      
        % end  %end for j
        % 
        % 
        % %updating the weights between the first hidden-layer & the second
        % for j=1:1:output_neurons
        %        delta_hh(1,j);
        %        for  i=1:1:output_neurons
        %           delta_hh(1,j)=delta_hh(1,j)+delta_o(1,i)*pw_ho(j,i); 
        %        end%end for i
        %         delta_hh(1,j)=hide2_neuron_out(1,j)*(1-hide2_neuron_out(1,j))*delta_hh(1,j);
        % end  %end for j
        % 
        % 
        %   %*****************************update*********************
        % for j=1:1:max_k2
        % 	for i=1:hidden_neurons
        %         next.w_hh(i,j)=pw_hh(i,j)+eta2*delta_hh(1,j)* hide1_neuron_out(1,i)+alfa*(pw_hh(i,j)-old.w_hh(i,j));
        %     end %end for i
        %     
        %     next.theta_h2(1,j)=theta_h2(1,j)+eta2*delta_hh(1,j)+alfa*(theta_h2(1,j)-old.theta_h2(1,j));
        % end %end for j
        % 
        % %updating the weights between input & first hidden layer
        % 
        % for j=1:1:hidden_neurons
        %        delta_ih(1,j)=0;
        %        for  i=1:max_k2 
        %            delta_ih(1,j)=delta_ih(1,j)+delta_hh(1,i)*pw_hh(j,i);
        %        end
        %        delta_ih(1,j)=hide1_neuron_out(1,j)*(1-hide1_neuron_out(1,j))*delta_ih(1,j);
        % end %end compute
        % %start update
        % 
        % for j=1:1:hidden_neurons
        %     for i=1:1:input_neurons 
        %     	next.w_ih(i,j)=pw_ih(i,j)+eta1*delta_ih(1,j)*x(1,i)+alfa*(pw_ih(i,j)-old.w_ih(i,j));
        %     end
        %     
        %     next.theta_h1(1,j)=theta_h1(1,j)+eta1*delta_ih(1,j)+alfa*(theta_h1(1,j)-old.theta_h1(1,j));
        %        
        % end %end j


  %change present past next
old.w_ih=pw_ih;
old.w_hh=pw_hh;
old.w_ho=pw_ho;
old.theta_h1=ptheta_h1;
old.theta_h2=ptheta_h2;
old.theta_o=ptheta_o;
pw_ih=next.w_ih;
pw_hh=next.w_hh;
pw_ho=next.w_ho;
ptheta_h1=next.theta_h1;
ptheta_h2=next.theta_h2;
ptheta_o=next.theta_o;


[m1,n1]=size(ct);
cc=1;


      counter=counter+1;
      max_err=-10000;
compare=zeros(300,21);

for l=1:1:300 %repeat for 300 pattern for test

    
d=ct(l,65);  %y that expected
y(1,d+1)=1;


% THIS NEXT PART LOOKS LIKE ITS BEEN COPY/PASTED 
% (MAY NOT BE NECESSARY)


%work with present

    for j=1:1:hidden_neurons %compute input-neuron in first hidden layer
        neuron_input=0;
        for i=1:1:input_neurons
            neuron_input=neuron_input+x(1,i)*pw_ih(i,j);
        end
        neuron_input= neuron_input+ptheta_h1(j);
        %factivation
        activation_output=0;
        if neuron_input < -30 
        activation_output=0;
        elseif neuron_input > 30 
            activation_output=1;
            else
                activation_output=1/(1+exp(-1*neuron_input));
        end
        hide1_neuron_out(1,j)= activation_output;
        %********************** 
    end
end
%*****************************************************
for j=1:1:max_k2 %compute input to neuronj in second hidden layer
  neuron_input=0;
    for i=1:1:hidden_neurons
        neuron_input=neuron_input+hide1_neuron_out(1,i)*pw_hh(i,j);
    end
   neuron_input= neuron_input+ptheta_h2(j);
   %factivation
   activation_output;
   if neuron_input < -30 
       activation_output=0;
   elseif neuron_input > 30 
           activation_output=1;
       else
         activation_output=1/(1+exp(-1*neuron_input));
   end
   hide2_neuron_out(1,j)= activation_output;
   %********************** 
   
end
%*********************************************
for j=1:1:output_neurons %compute input to neuron j in output layer
  neuron_input=0;
    for i=1:1:max_k2
    neuron_input=neuron_input+hide2_neuron_out(1,i)*pw_ho(i,j);
    end
   neuron_input= neuron_input+ptheta_o(j);
   %factivation
   activation_output;
   if neuron_input < -30 
       activation_output=0;
   elseif neuron_input > 30 
           activation_output=1;
       else
         activation_output=1/(1+exp(-1*neuron_input));
   end
   y_a(j,l)= activation_output;
     %rond y_a
   if y_a(j,1)>0.5
       y_a(j,1)=1;
   else
       y_a(j,1)=0;
   end
   delta_output(1,j)=y(1,j)-y_a(j,l);
   %********************** 
   
end