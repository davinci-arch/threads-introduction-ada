with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Unchecked_Deallocation;
use Ada.Text_IO, Ada.Integer_Text_IO;

procedure Main is

   amountOfThreads: Integer;
   type StepTaskArray is array (Integer range <>) of Integer;
   isRunning: Boolean := True;


   procedure ToString(id: Integer;
                      amount: Long_Long_Integer ;
                      result: Long_Long_Integer ;
                      step: Integer);

   procedure ToString(id: Integer;
                      amount: Long_Long_Integer ;
                      result: Long_Long_Integer ;
                      step: Integer) is
   begin
      Put_Line(Character'Val(10) & "Id thread: " & id'image &
                 Character'Val(10) & "Amount of iterations: " & amount'image &
                 Character'Val(10) & "Result of calc: " & result'image &
                 Character'Val(10) & "Step: " & step'image &
                 Character'Val(10) & "======================================================");
   end ToString;

   task type CalculateProgressionThread is
      entry Start(id: Integer; step: Integer);
   end CalculateProgressionThread;

   task type TaskScheduler is
      entry Start;
   end TaskScheduler;

   type ThreadsArr is array (Integer range <>) of CalculateProgressionThread;

   task body CalculateProgressionThread is
      result: Long_Long_Integer  := 0;
      amountOfIteration: Long_Long_Integer  := 0;
      idCopy: Integer;
      stepCopy: Integer;
   begin
      accept Start(id: Integer; step: Integer) do
         idCopy:= id;
         stepCopy:= step;
      end Start;
      while(isRunning) loop
         result := result + Long_Long_Integer'Value(stepCopy'image);
         amountOfIteration := amountOfIteration + 1;
      end loop;
      ToString(idCopy, amountOfIteration, result, stepCopy);
   end CalculateProgressionThread;

   task body TaskScheduler is
   begin
      accept Start do
         delay 3.0;
         isRunning:= False;

      end Start;
   end TaskScheduler;
begin
   Put("Write amount of threads: ");
   Get(amountOfThreads);

   declare
      stepsArr: StepTaskArray (1 .. amountOfThreads);
      step: Integer;
      threads: ThreadsArr (1 .. amountOfThreads);
      scheduler: TaskScheduler;
   begin
      for i in stepsArr'Range loop
         Put("Write an step of regression: ");
         Get(step);
         stepsArr(i) := step;
      end loop;

      for i in stepsArr'Range loop
         threads(i).Start(i, stepsArr(i));
      end loop;

      scheduler.Start;
   end;

end Main;
