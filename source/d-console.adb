Package body Devices.Console is
	procedure Write
		(Char : in Character;
		 X : in Screen_Width;
		 Y : in Screen_Height;
		 Attributes : in Attribute := Current_Attribute) is
	begin
		Console (Y)(X).Char := Char;
		Console (Y)(X).Attributes := Attributes;
	end Write;

	procedure Write
		(Str : in String;
	     X : in Screen_Width;
	     Y : in Screen_Height;
	     Attributes : in Attribute := Current_Attribute) is
	begin
		for Index in Str'First .. Str'Last loop
			Write (Str (Index),
				   X + Screen_Width (Index) - 1,
				   Y,
				   Attributes);
		end loop;
	end Write;

	procedure Blank is
	begin
		for X in Screen_Width'First .. Screen_Width'Last loop
			for Y in Screen_Height'First .. Screen_Height'Last loop
				Write(' ', X, Y, Current_Attribute);
			end loop;
		end loop;
	end Blank;
end Devices.Console;