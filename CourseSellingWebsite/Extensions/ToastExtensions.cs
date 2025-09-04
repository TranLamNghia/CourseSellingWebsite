using Microsoft.AspNetCore.Mvc.ViewFeatures;

namespace CourseSellingWebsite.Extensions
{
    public enum ToastType { Success, Error, Warning, Info }

    public static class ToastExtensions
    {
        public static void SetToast(this ITempDataDictionary temp,
            ToastType type, string message, string? title = null, int durationMs = 3500)
        {
            temp["Toast_Type"] = type.ToString().ToLowerInvariant();
            temp["Toast_Title"] = title ?? "Thông báo";
            temp["Toast_Message"] = message;
            temp["Toast_Duration"] = durationMs;
        }
    }
}
