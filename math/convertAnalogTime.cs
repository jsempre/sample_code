public class convertAnalogTime(int hour, int minute){
	int degreePerMinute = 6;
	int degreePerHour = 30;
	int degreeInCircle = 360;
	int minuteProgressInHour;
	if(hour >= 1 && hour <=12 && minute >= 0 && minute <= 60){
		//Analog clock has 60 minutes, 360 degrees in circle so each minute increases by 6 degrees
		int minuteAngle = minute * degreePerMinute;
		//Analog clock has 12 hours, 360 degrees in circle so each hour increases by 30 degrees plus current minute progress around clock.
    int minuteProgressInHour = minuteAngle / 12; 
    //Additional hour angle increases due to minute hand progress around clock
	  int hourAngle = (hour * degreePerHour) + minuteProgressInHour;
	}
	//Calculate angle between hands, always positive
	int angleBetweenHands = math.abs(hourAngle - minuteAngle);
	
	//To ensure inner angle is returned, if angle is outer, over 180 degrees, return inverse angle.
	if(angleBetweenHands > 180){
		angleBetweenHands = degreeInCircle - angleBetweenHands;
	}
return angleBetweenHands;
}
