
max_m=4;         %input neurons
max_k1=5;        %first hidden layer neurons
max_n=5;          %output neurons

% INPUT, HIDDEN LAYER x2, and OUTPUT ARRAYS
in_vector=zeros(1,max_n);
hide1_vector=zeros(1,max_k1);
out_vector=zeros(1,max_n);

% ARRAYS OF RANDOM WEIGHTS BETWEEN EACH LAYER
w0=randn(max_m,max_k1)*0.001;   
w2=randn(max_k1,max_n)*0.001;

% OUTPUT MATRIX (INITIALIZED TO ZERO)
outmatrix=zeros(max_n,max_no_pat);  

% THETA AND NEURONS
theta_h1=randn(1,max_k1)*0.001;   

theta_o=randn(1,max_n)*0.001;    
hide1_neuron_out=zeros(1,max_k1);  
delta_ih=zeros(1,max_k1);    
y_out=zeros(max_n,max_no_pat);  
err=zeros(1,max_n);   
x=zeros(1,max_m);    
y=zeros(1,max_n);    
y_a=zeros(max_n,max_no_pat);    
d=0;
delta_o=zeros(1,max_n);
find_num=zeros(max_no_pat,10);

% PRESENT
pw_ih=randn(max_m,max_k1)*0.001;ptheta_h1=randn(1,max_k1)*0.001;
pw_ho=randn(max_k1,max_n)*0.001;ptheta_o=randn(1,max_n)*0.001;

% PAST
old.w_ih=zeros(max_m,max_k1);old.theta_h1=zeros(1,max_k1);
old.w_ho=zeros(max_k1,max_n);old.theta_o=zeros(1,max_n);

% FUTURE
next.w_ih=zeros(max_m,max_k1);next.theta_h1=zeros(1,max_k1);
next.w_ho=zeros(max_k1,max_n);next.theta_o=zeros(1,max_n);

g=randn(1,4);


% ETA AND ALFA
eta1=0.62;eta2=0.62;eta3=0.62;alfa=0.1;


% MAIN LOOP
counter=0;
for e=1:10

% WHERE THE OLD DATA BLOCK WAS (80%)

[m,n]=size(c);

cc=1;
err_new=0;
      counter=counter+1;
      max_err=-10000;
        
end 

% WHERE THE OLD DATA BLOCK WAS (20%)

d=c(1,65);  %y that expected
y(1,d+1)=1;


%work with present

for j=1:1:max_k1 %compute input-neuron in first hidden layer
  neuron_input=0;
    for i=1:1:max_m
    neuron_input=neuron_input+x(1,i)*pw_ih(i,j);
    end
   neuron_input= neuron_input+ptheta_h1(j);
   %factivation
   komak2=0;
   if neuron_input < -30 
       komak2=0;
   else if neuron_input > 30 
           komak2=1;
       else
         komak2=1/(1+exp(-1*neuron_input));
       end
   hide1_neuron_out(1,j)= komak2;
   %********************** 
   
end
end
%*****************************************************
for j=1:1:max_k2 %compute input to neuronj in second hidden layer
  neuron_input=0;
    for i=1:1:max_k1
    neuron_input=neuron_input+hide1_neuron_out(1,i)*pw_hh(i,j);
    end
   neuron_input= neuron_input+ptheta_h2(j);
   %factivation
   komak2=0;
   if neuron_input < -30 
       komak2=0;
   else if neuron_input > 30 
           komak2=1;
       else
         komak2=1/(1+exp(-1*neuron_input));
       end
   hide2_neuron_out(1,j)= komak2;
   %********************** 
   
end
end
%*********************************************
for j=1:1:max_n %compute input to neuron j in output layer
  neuron_input=0;
    for i=1:1:max_k2
    neuron_input=neuron_input+hide2_neuron_out(1,i)*pw_ho(i,j);
    end
   neuron_input= neuron_input+ptheta_o(j);
   %factivation
   komak2=0;
   if neuron_input < -30 
       komak2=0;
   else if neuron_input > 30 
           komak2=1;
       else
         komak2=1/(1+exp(-1*neuron_input));
       end
   y_a(j,l)= komak2;
   err(1,j)=y(1,j)-y_a(j,l);
   %********************** 
   
end
end
%*****************compute & save pattern error
 pat_err=err(1,1)*err(1,1);
               for j=2:max_n 
                 pat_err=pat_err+err(1,j)*err(1,j);
               end
               
               err_new=err_new +pat_err;
               if pat_err>max_err 
                   max_err=pat_err;
                   Max_idx=l;
               end;
%************* BACKPROPAGATE THE ERRORS***************

%updating the weights between (second)hidden layer& output layer
 for j=1:1:max_n 
     delta_o(1,j)=y_a(j,l)*(1-y_a(j,l))*err(j);
 end
 
  for j=1:1:max_n
      
     for i=1:1:max_k2 
         next.w_ho(i,j)=pw_ho(i,j)+eta3*delta_o(1,j)*(hide2_neuron_out(1,i))+alfa*(pw_ho(i,j)-old.w_ho(i,j));
     end
        next.theta_o(1,j)=ptheta_o(1,j)+eta3*delta_o(1,j)+alfa*(ptheta_o(1,j)-old.theta_o(1,j));
     
  end  %end for j
  %updating the weights between the first hidden-layer & the second
  for j=1:1:max_k2
       delta_hh(1,j)=0;
       for  i=1:1:max_n
          delta_hh(1,j)=delta_hh(1,j)+delta_o(1,i)*pw_ho(j,i); 
       end%end for i
        delta_hh(1,j)=hide2_neuron_out(1,j)*(1-hide2_neuron_out(1,j))*delta_hh(1,j);
  end%end for j
  %*****************************update*********************
 for j=1:1:max_k2
     for i=1:max_k1
         next.w_hh(i,j)=pw_hh(i,j)+eta2*delta_hh(1,j)* hide1_neuron_out(1,i)+alfa*(pw_hh(i,j)-old.w_hh(i,j));
     end%end for i
     next.theta_h2(1,j)=theta_h2(1,j)+eta2*delta_hh(1,j)+alfa*(theta_h2(1,j)-old.theta_h2(1,j));
 end%end for j
 %updating the weights between input & first hidden layer
  for j=1:1:max_k1
       delta_ih(1,j)=0;
       for  i=1:max_k2 
           delta_ih(1,j)=delta_ih(1,j)+delta_hh(1,i)*pw_hh(j,i);
       end
       delta_ih(1,j)=hide1_neuron_out(1,j)*(1-hide1_neuron_out(1,j))*delta_ih(1,j);
  end%end compute
  %start update
  for j=1:1:max_k1
       for i=1:1:max_m 
           next.w_ih(i,j)=pw_ih(i,j)+eta1*delta_ih(1,j)*x(1,i)+alfa*(pw_ih(i,j)-old.w_ih(i,j));
       end
        next.theta_h1(1,j)=theta_h1(1,j)+eta1*delta_ih(1,j)+alfa*(theta_h1(1,j)-old.theta_h1(1,j));
       
  end%end j
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
%end of loop l read patern***********************
end
err_new=sqrt(err_new/max_no_pat);
err_new
%end of loop e epoch
end
[m1,n1]=size(ct);
cc=1;
err_new=0;

      counter=counter+1;
      max_err=-10000;
compare=zeros(300,21);

for l=1:1:300 %repeat for 300 pattern for test

    
for i=1:1:64  %read patern
    x(1,i)=ct(l,i);
   
end 
d=ct(l,65);  %y that expected
y(1,d+1)=1;

%work with present

for j=1:1:max_k1 %compute input-neuron in first hidden layer
  neuron_input=0;
    for i=1:1:max_m
    neuron_input=neuron_input+x(1,i)*pw_ih(i,j);
    end
   neuron_input= neuron_input+ptheta_h1(j);
   %factivation
   komak2=0;
   if neuron_input < -30 
       komak2=0;
   else if neuron_input > 30 
           komak2=1;
       else
         komak2=1/(1+exp(-1*neuron_input));
       end
   hide1_neuron_out(1,j)= komak2;
   %********************** 
   
end
end
%*****************************************************
for j=1:1:max_k2 %compute input to neuronj in second hidden layer
  neuron_input=0;
    for i=1:1:max_k1
    neuron_input=neuron_input+hide1_neuron_out(1,i)*pw_hh(i,j);
    end
   neuron_input= neuron_input+ptheta_h2(j);
   %factivation
   komak2=0;
   if neuron_input < -30 
       komak2=0;
   else if neuron_input > 30 
           komak2=1;
       else
         komak2=1/(1+exp(-1*neuron_input));
       end
   hide2_neuron_out(1,j)= komak2;
   %********************** 
   
end
end
%*********************************************
for j=1:1:max_n %compute input to neuron j in output layer
  neuron_input=0;
    for i=1:1:max_k2
    neuron_input=neuron_input+hide2_neuron_out(1,i)*pw_ho(i,j);
    end
   neuron_input= neuron_input+ptheta_o(j);
   %factivation
   komak2=0;
   if neuron_input < -30 
       komak2=0;
   else if neuron_input > 30 
           komak2=1;
       else
         komak2=1/(1+exp(-1*neuron_input));
       end
   y_a(j,l)= komak2;
     %rond y_a
   if y_a(j,1)>0.5
       y_a(j,1)=1;
   else
       y_a(j,1)=0;
   end
   err(1,j)=y(1,j)-y_a(j,l);
   %********************** 
   
end
end

%*****************compute & save pattern error
 
pat_err=err(1,1)*err(1,1);
 
               for j=2:max_n 
                 pat_err=pat_err+err(1,j)*err(1,j);
               end
                  %rond pat_ree
   if pat_err>=1
      pat_err=1;
   else
       pat_err=0;
   end
               err_new=err_new +pat_err;
               if pat_err>max_err 
                   max_err=pat_err;
                   Max_idx=l;
               end
 
                         
end
              err_new=sqrt(err_new/300);
err_new


      

     
 
 
 