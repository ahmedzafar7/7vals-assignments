#code citation: https://github.com/sj26/ruby-1.9.3-p0/blob/master/sample/cal.rb
#I used some method code from over here and modified according to assignment requirements, thought this would be good since
#opensource is encouraged
class DateStuff
	require 'date'
	attr_accessor :appointment_date #want to write this variable from outside class
	def initialize(date)
		@input_date = date #global
	end
	def show_calendar_from_date
		#show calendar from @input_date
		begin
			parsed = Date.parse(@input_date) #if date is invalid Exception will be caught and program will exit
		rescue ArgumentError
   		# handle invalid date
   		puts "The date you have entered seems to be invalid-- The program will now exit"
   		exit   		#exits program, another alternative would've been to restart script
   	end

		#puts "The date you entered is #{@input_date}" #just debugging stuff
	end
	
	def to_print_calendar_this
		d,m,y = @input_date.split("-").map(&:to_i) #convert all to integer from string after splitting by -
		#puts "#{d} #{m} #{y}" #just for debugging
		d = (d..31).detect{|x| Date.valid_date?(y, m, x)} #returns values for which block is not false
		fi = Date.new(y, m, d)
		if @appointment_date #if the value of this variable is not nil--- hence has been set
			date_range = (Date.parse(@input_date)..fi>>1) #one month range from @input_date
    		#puts "date range: #{date_range}"
    		if !date_range.include?(Date.parse(appointment_date)) #checks whether the appointment is in the one month range
    			puts "Your appointment does not seem to fit in the given calendar range, the program will now exit"
    			exit
    		end
		#da,ma,ya = @appointment_date.split("-").map(&:to_i) #variables store appointment date #not needed anymore
		begin
			appointment_date_is = Date.parse(@appointment_date) 
		rescue ArgumentError
			puts "The appointment date you have entered seems to be invalid-- The program will now exit"
			exit
		end
   		#check if appointment date is in range
   	end
   	#puts "before fi: #{fi}" #debugging
   	fi -= (fi.jd + 1) % 7 #offsets dates so they show correctly when calendar rendered
   #	puts "after fi: #{fi}" #debugging


   	ve  = (fi..fi +  6).collect{|cu|
   		%w(S M Tu W Th F S)[cu.wday]
   	}
   	ve += (fi..fi +41).collect{|cu|
   		if @appointment_date
   			if cu.mon == m && appointment_date_is!=cu #month is inputted month and appointment date is not this date
       cu.send(:mday) if cu.mday >=d #don't print it if it's before d
   elsif cu.mon == m && appointment_date_is==cu #its the appointment date, mark calendar with an X
   	cu = "#{cu.mday}(X)" if cu.mday >=d
   end.to_s 
else #appointment date not set, proceed as normal
	if cu.mon == m
       cu.send(:mday) if cu.mday >=d #don't print it if it's before d
   end.to_s 
end

}

ve = ve.collect{|e| e.rjust(2)}

gr = group(ve, 7)
   # gr = trans(gr) if @opt_t
   ta = gr.collect{|xs| xs.join(' ')}

   ca = %w(January February March April May June July
   	August September October November December)[m - 1]
   #ca = ca + ' ' + y.to_s if !@opt_y
   @mw = 3 * 7 - 1

   ca = ca.center(@mw)

   ta.unshift(ca)
end

def to_print_calendar_next 

	#da,ma,ya = @appointment_date.split("-").map(&:to_i) if @appointment_date #not needed anymore
	appointment_date_is = Date.parse(@appointment_date) if @appointment_date


		d,m,y = @input_date.split("-").map(&:to_i) #convert all to integer from string
		
		m += 1 if m < 12
		if m == 12
			m=1
			y+=1 ##increment month and year by one since last month was end of year
		end


		di = (1..d).detect{|x| Date.valid_date?(y, m, x)}
		fi = Date.new(y, m, di)
    #check if appointment date is within the given calendar

    fi -= (fi.jd + 1) % 7

    ve  = (fi..fi +  6).collect{|cu|
    	%w(S M Tu W Th F S)[cu.wday]
    }

    ve += (fi..fi+41).collect{|cu|
    	if @appointment_date

    		if cu.mon == m && appointment_date_is!=cu
       cu.send(:mday) if cu.mday <=d #don't print it if it's before d
       elsif cu.mon == m && appointment_date_is==cu #its the appointment date, mark calendar with an X
       	cu = "#{cu.mday}(X)" if cu.mday <=d
       end.to_s 
   else
   	if cu.mon == m
       cu.send(:mday) if cu.mday <=d #don't print it if it's before d #still have to completely figure out what send does
   end.to_s 
end
}

ve = ve.collect{|e| e.rjust(2)} #righjt justfified, basically the distance between columns of calendar (practically), for aesthetic purposes

gr = group(ve, 7)
   # gr = trans(gr) if @opt_t
   ta = gr.collect{|xs| xs.join(' ')}

   ca = %w(January February March April May June July
   	August September October November December)[m - 1] #uses to display month on top of calendar according to m
   #ca = ca + ' ' + y.to_s if !@opt_y
   @mw = 3 * 7 - 1

   ca = ca.center(@mw)

   ta.unshift(ca) #adds ca to beginning of array
end

def group(xs, n)
	(0..xs.size / n - 1).collect{|i| xs[i * n, n]}
end
def unlines(xs)
	xs.collect{|x| x + "\n"}.join
end
  def print_this_month#default is false
  	unlines(to_print_calendar_this)
  end
  def print_next_month #default is false
  	unlines(to_print_calendar_next)
  end
end

puts "Enter a date in format dd-mm-yyyy"

date1 = gets #get input from keyboard #validity of date checks are in place
#date2 = "17-03-2016" #replace with gets for keyboard input #redundant

dateclass1 = DateStuff.new(date1) #new object
#dateclass2 = DateStuff.new(date2) #avoided creating new classes if not necessary


dateclass1.show_calendar_from_date
#dateclass2.show_calendar_from_date

print dateclass1.print_this_month #DRY got compromised over here as print_this_month and print_next_month use a lot of the same code
print dateclass1.print_next_month #unfortunately

puts "Enter a date for an appointment you may have in the format dd-mm-yyyy"
dateclass1.appointment_date = gets #get input from keyboard #validity of date checks are in place

print dateclass1.print_this_month  #true signals there is an appointment
print dateclass1.print_next_month #print accordingly

puts "Your appointment date #{dateclass1.appointment_date.delete("\n")} is marked with an (X)"