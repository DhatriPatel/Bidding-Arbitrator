module arb (bmif.mstrR a_m0,bmif.mstrR a_m1, bmif.mstrR a_m2, bmif.mstrR a_m3, svif.slvR a_s0, svif.slvR a_s1, svif.slvR a_s2, svif.slvR a_s3, input integer bidamt, input integer time_interval, input integer max_amount );

integer bid0,bid0l,tm0,tm0l; //FFEF_0200
integer bid1,bid1l,tm1,tm1l; //FFEF_1200
integer bid2,bid2l,tm2,tm2l; // FFEF_2200
integer bid3,bid3l,tm3,tm3l; //FFEF_3200
integer cnt,cnt_l;
logic[1:0] tag0,tag1,tag2,tag3;


always @ (posedge a_m0.clk)
begin
	bid0 <= #1 bid0l;
	bid1 <= #1 bid1l;
	bid2 <= #1 bid2l;
	bid3 <= #1 bid3l;

	tm0 <= #1 tm0l;
	tm1 <= #1 tm1l;
	tm2 <= #1 tm2l;
	tm3 <= #1 tm3l;
	
    cnt <= #1 cnt_l;
end

//.... request to master .. bidding ,,,

always @ (*)
begin

	if (a_m0.rst)
	begin
		
		bid0l = max_amount;
		bid1l = max_amount;	
		bid2l = max_amount;
		bid3l = max_amount;
		
		tm0l = 0;
        tm1l = 0;
        tm2l = 0;
        tm3l = 0;
        
        tag0 = 0;
		tag1 = 1;
		tag2 = 2;
		tag3 = 3;
		cnt_l = 0;
		
        a_m0.grant = 0;
        a_m1.grant = 0;
        a_m2.grant = 0;
        a_m3.grant = 0;
        
	end
	else
	begin
		
		cnt_l = cnt + 1;
		if (cnt == time_interval)
		begin
			cnt_l = 0;
			if ((bid0 + bidamt) < max_amount)
			begin
				bid0l = bid0 + bidamt;
			end	
			else
			begin
				bid0l = max_amount;	
			end
			if ((bid1 + bidamt) < max_amount)
			begin
				bid1l = bid1 + bidamt;
			end	
			else
			begin
				bid1l = max_amount;	
			end
			if ((bid2 + bidamt) < max_amount)
			begin
				bid2l = bid2 + bidamt;
			end	
			else
			begin
				bid2l = max_amount;	
			end
			if ((bid3 + bidamt) < max_amount)
			begin
				bid3l = bid3 + bidamt;
			end	
			else
			begin
				bid3l = max_amount;	
			end
		end 
		
		if (a_m0.xfr == 0)
			a_m0.grant = 0;
		else if (a_m1.xfr == 0)
			a_m1.grant = 0;
		else if (a_m2.xfr == 0)
			a_m2.grant = 0;
		else if (a_m3.xfr == 0)
			a_m3.grant = 0;

	         if ((( bid1 == 1 ? 1 : a_m0.req >= a_m1.req ) && (bid2 ==1? 1 :a_m0.req >= a_m2.req) && (bid3 ==1? 1:a_m0.req >= a_m3.req) && a_m0.xfr == 1 && (bid0 ==1?0:1))||tm0 == 59||((bid1==1 | a_m1.req == 0) && (bid2==1 | a_m2.req == 0) && (bid3==1 | a_m3.req == 0) && a_m0.req != 0)&& tm1 < 59 && tm2 <59 && tm3 <59) 
             begin 
                    if (tag0 != 3)
                    begin
                            tag0 = 3;
                            if (tag3>tag2 && tag3>tag1 && tag2>tag1) 
                            begin 
                                    tag3 = 2; 
                                    tag2 = 1; 
                                    tag1 = 0; 
                            end
                            else if (tag2>tag1 && tag2>tag3 && tag3>tag1) 
                            begin 
                                    tag3 = 1; 
                                    tag2 = 2; 
                                    tag1 = 0; 
                            end
                            else if (tag3>tag2 && tag3>tag1 && tag1>tag2) 
                            begin 
                                    tag3 = 2; 
                                    tag2 = 0; 
                                    tag1 = 1; 
                            end
                            else if (tag2>tag1 && tag2>tag3 && tag1>tag3) 
                            begin 
                                    tag3 = 0; 
                                    tag2 = 2; 
                                    tag1 = 1; 
                            end
                            else if (tag1>tag2 && tag1>tag3 && tag3>tag2) 
                            begin 
                                    tag3 = 1; 
                                    tag2 = 0; 
                                    tag1 = 2; 
                            end
                            else if (tag1>tag2 && tag1>tag3 && tag2>tag3) 
                            begin 
                                    tag3 = 0; 
                                    tag2 = 1; 
                                    tag1 = 2; 
                            end
			end
			tm0l = 0;
			tm1l = tm1+1;
			tm2l = tm2+1;
			tm3l = tm3+1;
			a_m0.grant = 1;
			a_m1.grant = 0;
			a_m2.grant = 0;
			a_m3.grant = 0;
			if ((bid0 - a_m0.req)<=0 | (bid0 - a_m0.req > max_amount))
				bid0l = 1;
			else
				bid0l = bid0 - a_m0.req;
		end 
		
		if ((( bid0 == 1 ? 1 : a_m1.req >= a_m0.req ) && (bid2 ==1 ? 1: a_m1.req >= a_m2.req) && (bid3 ==1? 1:a_m1.req >= a_m3.req) && a_m1.xfr == 1  && (bid1==1?0:1))||(tm1 == 59))
		begin
			if (tag1 != 3)
			begin
			tag1 = 3;
				if (tag3>tag2 && tag3>tag0 && tag2>tag0) 
				begin 
                        tag3 = 2; 
                        tag2 = 1; 
                        tag0 = 0; 
                end
				else if (tag2>tag0 && tag2>tag3 && tag3>tag0) 
				begin 
                        tag3 = 1; 
                        tag2 = 2; 
                        tag0 = 0; 
                end
				else if (tag3>tag2 && tag3>tag0 && tag0>tag2) 
				begin 
                        tag3 = 2; 
                        tag2 = 0; 
                        tag0 = 1; 
                end
				else if (tag2>tag0 && tag2>tag3 && tag0>tag3) 
				begin 
                        tag3 = 0; 
                        tag2 = 2; 
                        tag0 = 1; 
                end
				else if (tag0>tag2 && tag0>tag3 && tag3>tag2) 
				begin 
                        tag3 = 1; 
                        tag2 = 0; 
                        tag0 = 2; 
                end
				else if (tag0>tag2 && tag0>tag3 && tag2>tag3) 
				begin 
                        tag3 = 0; 
                        tag2 = 1; 
                        tag0 = 2; 
                end
			end
			
			tm0l = tm0+1;
			tm1l = 0;
			tm2l = tm2+1;
			tm3l = tm3+1;
			a_m0.grant = 0;
			a_m1.grant = 1;
			a_m2.grant = 0;
			a_m3.grant = 0;
			
			if ((bid1 - a_m1.req)<=0 | (bid1 - a_m1.req > max_amount))
				bid1l = 1;
			else
				bid1l = bid1 - a_m1.req;
		end
		
		if ((( bid0 == 1 ? 1 : a_m2.req >= a_m0.req ) && (bid1 ==1? 1:a_m2.req >= a_m1.req) && (bid3 ==1? 1:a_m2.req >= a_m3.req) && a_m2.xfr == 1 && (bid2==1?0:1))||(tm2 == 59))
		begin
			if (tag2 != 3)
			begin
			tag2 = 3;
				if (tag3>tag0 && tag3>tag1 && tag0>tag1) 
				begin 
                        tag3 = 2; 
                        tag0 = 1; 
                        tag1 = 0; 
                end
				else if (tag0>tag1 && tag0>tag3 && tag3>tag1) 
				begin 
                        tag3 = 1; 
                        tag0 = 2; 
                        tag1 = 0; 
                end
				else if (tag3>tag0 && tag3>tag1 && tag1>tag0) 
				begin 
                        tag3 = 2; 
                        tag0 = 0; 
                        tag1 = 1; 
                end
				else if (tag0>tag1 && tag0>tag3 && tag1>tag3) 
				begin 
                        tag3 = 0; 
                        tag0 = 2; 
                        tag1 = 1; 
                end
				else if (tag1>tag0 && tag1>tag3 && tag3>tag0) 
				begin 
                        tag3 = 1; 
                        tag0 = 0; 
                        tag1 = 2; 
                end
				else if (tag1>tag0 && tag1>tag3 && tag0>tag3) 
				begin 
                        tag3 = 0; 
                        tag0 = 1; 
                        tag1 = 2; 
                end
			end
			
			tm0l = tm0+1;
			tm1l = tm1+1;
			tm2l = 0;
			tm3l = tm3+1;
			a_m0.grant = 0;
			a_m1.grant = 0;
			a_m2.grant = 1;
			a_m3.grant = 0;	
			if ((bid2 - a_m2.req)<=0 | (bid2 - a_m2.req > max_amount))
				bid2l = 1;
			else
				bid2l = bid2 - a_m2.req;
		end
		
		if ((( bid0 == 1 ? 1 : a_m3.req >= a_m0.req ) && (bid1 ==1? 1:a_m3.req >= a_m1.req) && (bid2 ==1? 1:a_m3.req >= a_m2.req) && a_m3.xfr == 1 && (bid3==1?0:1))||(tm3 == 59))
		begin
			if (tag3 != 3)
			begin
			tag3 = 3;
				if (tag0>tag2 && tag0>tag1 && tag2>tag1) 
				begin 
                        tag0 = 2; 
                        tag2 = 1; 
                        tag1 = 0; 
                end
				else if (tag2>tag1 && tag2>tag0 && tag0>tag1) 
				begin 
                        tag0 = 1; 
                        tag2 = 2; 
                        tag1 = 0; 
                end
				else if (tag0>tag2 && tag0>tag1 && tag1>tag2) 
				begin 
                        tag0 = 2; 
                        tag2 = 0; 
                        tag1 = 1; 
                end
				else if (tag2>tag1 && tag2>tag0 && tag1>tag0) 
				begin 
                        tag0 = 0; 
                        tag2 = 2; 
                        tag1 = 1; 
                end
				else if (tag1>tag2 && tag1>tag0 && tag0>tag2) 
				begin 
                        tag0 = 1; 
                        tag2 = 0; 
                        tag1 = 2; 
                end
				else if (tag1>tag2 && tag1>tag0 && tag2>tag0) 
				begin 
                        tag0 = 0; 
                        tag2 = 1;
                        tag1 = 2; 
                end
			end
			
			tm0l = tm0+1;
			tm1l = tm1+1;
			tm2l = tm2+1;
			tm3l = 0;
			a_m0.grant = 0;
			a_m1.grant = 0;
			a_m2.grant = 0;
			a_m3.grant = 1;	
			if ((bid3 - a_m3.req)<=0 | (bid3 - a_m3.req > max_amount))
				bid3l = 1;
			else
				bid3l = bid3 - a_m3.req;
		end 
	end
end

//...... after giving grant to master.....

always @ (*)
begin

if (a_m0.rst)
begin

        a_s0.sel = 0;
        a_s1.sel = 0;
        a_s2.sel = 0;
        a_s3.sel = 0;

end
else
begin	
		if (a_m0.grant == 1)
		begin
			case (a_m0.addr)
				32'hFFEF0200: begin
						a_s0.sel = 1;
						a_s1.sel = 0;
						a_s2.sel = 0;
						a_s3.sel = 0;
						a_s0.RW = a_m0.RW;
						a_s0.addr = a_m0.addr;
						a_s0.DataToSlave = a_m0.DataToSlave;
						a_m0.DataFromSlave = a_s0.DataFromSlave;
					   end
				32'hFFEF1200: begin
						a_s0.sel = 0;
						a_s1.sel = 1;
						a_s2.sel = 0;
						a_s3.sel = 0;
						a_s1.RW = a_m0.RW;
						a_s1.addr = a_m0.addr;
						a_s1.DataToSlave = a_m0.DataToSlave;
						a_m0.DataFromSlave = a_s1.DataFromSlave;
					   end
				32'hFFEF2200: begin
						a_s0.sel = 0;
						a_s1.sel = 0;
						a_s2.sel = 1;
						a_s3.sel = 0;
						a_s2.RW = a_m0.RW;
						a_s2.addr = a_m0.addr;
						a_s2.DataToSlave = a_m0.DataToSlave;
						a_m0.DataFromSlave = a_s2.DataFromSlave;
					   end
				32'hFFEF3200: begin
						a_s0.sel = 0;
						a_s1.sel = 0;
						a_s2.sel = 0;
						a_s3.sel = 1;
						a_s3.RW = a_m0.RW;
						a_s3.addr = a_m0.addr;
						a_s3.DataToSlave = a_m0.DataToSlave;
						a_m0.DataFromSlave = a_s3.DataFromSlave;
					   end		
				default : begin
						a_s0.sel =0;
						a_s1.sel =0;
						a_s2.sel =0;
						a_s3.sel =0;
						end	
			endcase		
		end
		if (a_m1.grant == 1)
		begin
			case (a_m1.addr)
				32'hFFEF0210: begin
						a_s0.sel = 1;
						a_s1.sel = 0;
						a_s2.sel = 0;
						a_s3.sel = 0;
						a_s0.RW = a_m1.RW;
						a_s0.addr = a_m1.addr;
						a_s0.DataToSlave = a_m1.DataToSlave;
						a_m1.DataFromSlave = a_s0.DataFromSlave;
					   end
				32'hFFEF1210: begin
						a_s0.sel = 0;
						a_s1.sel = 1;
						a_s2.sel = 0;
						a_s3.sel = 0;
						a_s1.RW = a_m1.RW;
						a_s1.addr = a_m1.addr;
						a_s1.DataToSlave = a_m1.DataToSlave;
						a_m1.DataFromSlave = a_s1.DataFromSlave;
					   end
				32'hFFEF2210: begin
						a_s0.sel = 0;
						a_s1.sel = 0;
						a_s2.sel = 1;
						a_s3.sel = 0;
						a_s2.RW = a_m1.RW;
						a_s2.addr = a_m1.addr;
						a_s2.DataToSlave = a_m1.DataToSlave;
						a_m1.DataFromSlave = a_s2.DataFromSlave;
					   end
				32'hFFEF3210: begin
						a_s0.sel = 0;
						a_s1.sel = 0;
						a_s2.sel = 0;
						a_s3.sel = 1;
						a_s3.RW = a_m1.RW;
						a_s3.addr = a_m1.addr;
						a_s3.DataToSlave = a_m1.DataToSlave;
						a_m1.DataFromSlave = a_s3.DataFromSlave;
					   end		
				default : begin
						a_s0.sel =0;
						a_s1.sel =0;
						a_s2.sel =0;
						a_s3.sel =0;
						end			
			endcase	
		end
		if (a_m2.grant == 1)
		begin
			case (a_m2.addr)
				32'hFFEF0220: begin
						a_s0.sel = 1;
						a_s1.sel = 0;
						a_s2.sel = 0;
						a_s3.sel = 0;
						a_s0.RW = a_m2.RW;
						a_s0.addr = a_m2.addr;
						a_s0.DataToSlave = a_m2.DataToSlave;
						a_m2.DataFromSlave = a_s0.DataFromSlave;
					   end
				32'hFFEF1220: begin
						a_s0.sel = 0;
						a_s1.sel = 1;
						a_s2.sel = 0;
						a_s3.sel = 0;
						a_s1.RW = a_m2.RW;
						a_s1.addr = a_m2.addr;
						a_s1.DataToSlave = a_m2.DataToSlave;
						a_m2.DataFromSlave = a_s1.DataFromSlave;
					   end
				32'hFFEF2220: begin
						a_s0.sel = 0;
						a_s1.sel = 0;
						a_s2.sel = 1;
						a_s3.sel = 0;
						a_s2.RW = a_m2.RW;
						a_s2.addr = a_m2.addr;
						a_s2.DataToSlave = a_m2.DataToSlave;
						a_m2.DataFromSlave = a_s2.DataFromSlave;
					   end
				32'hFFEF3220: begin
						a_s0.sel = 0;
						a_s1.sel = 0;
						a_s2.sel = 0;
						a_s3.sel = 1;
						a_s3.RW = a_m2.RW;
						a_s3.addr = a_m2.addr;
						a_s3.DataToSlave = a_m2.DataToSlave;
						a_m2.DataFromSlave = a_s3.DataFromSlave;
					   end	
				default : begin
						a_s0.sel =0;
						a_s1.sel =0;
						a_s2.sel =0;
						a_s3.sel =0;
						end				
			endcase	
		end
		if (a_m3.grant == 1)
		begin
			case (a_m3.addr)
				32'hFFEF0230: begin
						a_s0.sel = 1;
						a_s1.sel = 0;
						a_s2.sel = 0;
						a_s3.sel = 0;
						a_s0.RW = a_m3.RW;
						a_s0.addr = a_m3.addr;
						a_s0.DataToSlave = a_m3.DataToSlave;
						a_m3.DataFromSlave = a_s0.DataFromSlave;
					   end
				32'hFFEF1230: begin
						a_s0.sel = 0;
						a_s1.sel = 1;
						a_s2.sel = 0;
						a_s3.sel = 0;
						a_s1.RW = a_m3.RW;
						a_s1.addr = a_m3.addr;
						a_s1.DataToSlave = a_m3.DataToSlave;
						a_m3.DataFromSlave = a_s1.DataFromSlave;
					   end
				32'hFFEF2230: begin
						a_s0.sel = 0;
						a_s1.sel = 0;
						a_s2.sel = 1;
						a_s3.sel = 0;
						a_s2.RW = a_m3.RW;
						a_s2.addr = a_m3.addr;
						a_s2.DataToSlave = a_m3.DataToSlave;
						a_m3.DataFromSlave = a_s2.DataFromSlave;
					   end
				32'hFFEF3230: begin
						a_s0.sel = 0;
						a_s1.sel = 0;
						a_s2.sel = 0;
						a_s3.sel = 1;
						a_s3.RW = a_m3.RW;
						a_s3.addr = a_m3.addr;
						a_s3.DataToSlave = a_m3.DataToSlave;
						a_m3.DataFromSlave = a_s3.DataFromSlave;
					   end
				default : begin
						a_s0.sel =0;
						a_s1.sel =0;
						a_s2.sel =0;
						a_s3.sel =0;
						end				
			endcase	
		end 
	end
end
endmodule
