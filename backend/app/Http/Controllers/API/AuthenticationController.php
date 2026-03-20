<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\User;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use App\Models\Profile;

class AuthenticationController extends Controller
{
    //
    public function register(Request $request){

        try
        {

        $validateUser =Validator::make( $request->all(),[
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|unique:users',
            'password' => 'required|string|confirmed|min:8',
        ]);

        if($validateUser->fails()){
            return response()->json([
                'status'=>false,
                'messege'=>'validation error',
                'error'=>$validateUser->errors()
            ],401);
        }
        $user = new User([
            'name' => $request->name,
            'email' => $request->email,
            'password' => Hash::make($request->password),
            'userType' => 1, // Set user_type to 2
        ]);

        $user->save();

        $token = $user->createToken('API Token')->plainTextToken;

        // Return success response with the generated token
        return response()->json([
            'status' => true,
            'message' => 'User registered successfully',
            'token' => $token,
        ], 201);
    } catch (\Throwable $th) {
        // If an exception occurs, return error response
        return response()->json([
            'status' => false,
            'message' => $th->getMessage(),
        ], 500);
    }
}
public function login(Request $request){

    try
    {

        $validateUser =Validator::make( $request->all(),[
            'email' => 'required|string|email',
            'password' => 'required|string|min:8',
        ]);

    if($validateUser->fails()){
        return response()->json([
            'status'=>false,
            'message'=>'validation error',
            'error'=>$validateUser->errors()
        ],401);
    }

    $credentials = $request->only('email', 'password');

    if (!Auth::attempt($credentials)) {
        return response()->json([
            'status'=>false,
            'message' => ' Email or Password does not match our records '], 401);
    }

    $user = auth()->user();

    // Check if user_type is 2
    if ($user->userType != 1) {
        return response()->json([
            'status' => false,
            'message' => 'Unauthorized user',
        ], 401);
    }
    $token = $user->createToken("API_TOKEN")->plainTextToken;

     // Check if the user already has an API token
     return response()->json([
        'status' => true,
        'message' => 'User logged in Successfully',
        'token' => $token,
        'token_type' => 'Bearer',
    ], 200);
}
catch(\Throwable $th){
    return response()->json([
        'status'=>true,
        'message' =>$th->getMessage(),
    ],500);
}
}
public function logout(Request $request)
    {
        try {
            auth()->user()->tokens()->delete();
            return response()->json([
                'status'=>true,
                "message"=>"logged out succesfully"
              ]);
        }
         catch (\Throwable $th) {
        return response()->json([
            'status' => false,
            'message' => $th->getMessage(),
        ], 500);
    }
}
public function updateProfile(Request $request)
    {
        try{

        // Validate the incoming request data
        $validatedData = Validator::make($request->all(),[
            'first_name' => 'required|string',
            'last_name' => 'required|string',
            'street' => 'required|string',
            'city' => 'required|string',
            'country' => 'required|string',
            'phone_number' => ['required', 'string', 'regex:/^(06|07)[0-9]{8}$/'],
            'date_of_birth' => 'required|date',
            'gender' => 'required|string',
        ]);

        if($validatedData->fails()){
            return response()->json([
                'status'=>false,
                'messege'=>'validation error',
                'error'=>$validatedData->errors()
            ],401);
        }

        // Get the authenticated user
        $user = auth()->user();


        // Fetch email and username from the authenticated user
        $email = $user->email;
        $username = $user->name;

         // Check if the user already has a profile
         $profile = User::where('email', $user->email)->first();

         if (!$profile) {
            // Profile doesn't exist, create a new one
            $profile = new User();
            $profile->email = $email; // Set email retrieved from the authenticated user
            $profile->username = $username; // Set username retrieved from the authenticated user
        }
        // Update profile fields with the validated data and user's email/username
        $profile->email = $email;
        $profile->username = $username;
        $profile->first_name = $request->input('first_name');
        $profile->last_name = $request->input('last_name');
        $profile->street = $request->input('street');
        $profile->city = $request->input('city');
        $profile->country = $request->input('country');
        $profile->phone_number = $request->input('phone_number');
        $profile->date_of_birth = $request->input('date_of_birth');
        $profile->gender = $request->input('gender');

        // Save the profile changes
        $profile->save();

        return response()->json([
            'status' => true,
            'message' => 'Profile updated successfully']);
    }
catch (\Throwable $th) {
    return response()->json([
        'status' => false,
        'message' => $th->getMessage(),
    ], 500);
}}
public function getProfile(Request $request)
{
    $user = auth()->user();
    $profile = User::where('email', $user->email)->first();
    if (!$profile) {
        return response()->json([
            'status' => false,
            'message' => 'Profile not found',
        ], 404);
    }
    return response()->json([
        'status' => true,
        'data' => $profile,
    ]);
}
public function deleteAccount(Request $request)
{
    try {
        // Get the authenticated user
        $user = auth()->user();

        // Delete the user's profile
        $profile = User::where('email', $user->email)->first();
        if ($profile) {
            $profile->delete();
        }



        return response()->json([
            'status' => true,
            'message' => 'User account deleted successfully'
        ]);
    } catch (\Throwable $th) {
        return response()->json([
            'status' => false,
            'message' => $th->getMessage(),
        ], 500);
    }
}
}
