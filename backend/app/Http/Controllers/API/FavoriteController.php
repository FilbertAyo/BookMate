<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Favorite;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Auth;
use Illuminate\Http\Request;

class FavoriteController extends Controller
{
    public function addToCart(Request $request)
{
    try{
        // Validate request data
        $validateUser = Validator::make($request->all(), [
            'title' => 'required|string|max:255',
            'authors' => 'required',
            'publisher' => 'required',
            'categories' => 'required',
            // 'description' => 'required',
            'thumbnailUrl' => 'required',
            'publishedDate' => 'required',
          ]);

        if($validateUser->fails()){
          return response()->json([
              'status'=>false,
              'message'=>'validation error',
              'error'=>$validateUser->errors()
          ],401);
      }

      $userId = auth()->id();
    //   $pharmacy = Product::where('name', $request->pharmacyName)->first();
    // $pharmacy = Product::all();
        // Create a new Cart item
        $book = Favorite::create([
            'user_id' => $userId,
            // 'product_id'=>$pharmacy->id,
            'title' => $request->title,
            'thumbnailUrl' => $request->thumbnailUrl,
            'authors' => $request->authors,
            'publisher' => $request->publisher,
            'categories' => $request->categories,
            // 'description' => $request->description,
            'publishedDate' => $request->publishedDate,
        ]);

        $book->save();
        if ($book) {
            // Item added successfully
            return response()->json([
              'status' => true,
              'message' => 'Book added to cart successfully!',
              'data' => $book,
            ]);
          } else {
            // Item addition failed (handle error)
            return response()->json([
              'status' => false,
              'message' => 'Failed to add book to cart.', // Provide a specific error message
            ], 500);
          }
    }
    catch (\Throwable $th) {
        return response()->json([
            'status' => false,
            'message' => $th->getMessage(),
        ], 500);
    }
}

public function getMyCart()
{
    try {

        $user = auth()->user();

    // $book = Favorite::get();
    $book = Favorite::where('user_id', $user->id)->get();

    if(!$book){
        return response()->json([
            'status'=>false,
            'message'=>'no cart available',
        ],401);
    }


    return response()->json([
        'status' => true,
        'data' => $book,
    ]);


    } catch (\Throwable $th) {
        return response()->json([
            'status' => false,
            'message' => $th->getMessage()
        ], 500);
    }
}

}
