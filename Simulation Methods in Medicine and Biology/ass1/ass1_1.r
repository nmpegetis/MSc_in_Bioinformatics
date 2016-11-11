Nspheres = 10^4
k1 = 1
k2 = 2
k3 = 3
L = 90
H = L/10
R1 = runif(Nspheres, min=0, max=1)
theta = (pi*R1)/4
R2 = runif(Nspheres, min=0, max=1)
E = 25/(5-4*R2)
collisions = 0
spheres = matrix(0, nrow=1, ncol=Nspheres)   # collisions per sphere
x0 = tan(theta)*H   		# distance until the first collision to the strings
for(i in 1:Nspheres){
	if(x0[i] <= L){   		# if distance <= length of elastic layer ==> collision occurs
		x = x0[i]
		repeat{
			collisions = collisions + 1
			spheres[i] = spheres[i] + 1
			y = (x/3) %% 3 	# with x position in the elastic layer known, the string that it collides with is found using the molulo 3
			R = runif(1, min=0, max=1)
			if((y >= 0) & (y < 1)){   		# string with k1
				k=k1
			}
			else if((y >= 1) & (y < 2)){	#string with k2
				k=k2
			}
			else{							#string with k3
				k=k3
			}
			xi = log(1-R*(1-exp(-k*E[i]*90)))/(-k*E[i])

			x = x + xi   # adding distance to previous distance of each sphere
			if(x > L){   	 # do until sphere reaches the end of the elastic layer
				break
			}
		}
	}
}
print(paste("The total number of collisions on the elastic layer is: ",collisions))
median_collisions = collisions/Nspheres
print(paste("The median number of collisions per sphere on the elastic layer is: ",median_collisions))
print("The plot of sphere's energy per sphere collisions is: ")
plot(E,spheres,col="lightblue")
print("The plot of sphere's angle per sphere collisions is: ")
#windows()	# Windows
X11()		# Unix
#quartz()	# Mac
plot(theta,spheres,col="blue")
